import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final List<String> _messages = [];
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistente Tuga - Teste'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          TextField(
            controller: _controller,
            onSubmitted: (value) {
              _sendMessage(value);
              _controller.clear();
            },
            decoration: const InputDecoration(
              labelText: 'Enter your message',
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) async {
    setState(() {
      _messages.add('User: $message');
    });

    final response = await _getGptResponse(message);

    final directory = await getApplicationDocumentsDirectory();
    final speechOutputDirectory = Directory('${directory.path}/speechOutput');
    if (!await speechOutputDirectory.exists()) {
      await speechOutputDirectory.create();
    }
    final audioFile = await OpenAI.instance.audio.createSpeech(
      model: "tts-1",
      input: response!,
      voice: "onyx",
      speed: 1.1,
      responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
      outputDirectory: speechOutputDirectory,
      outputFileName: "response",
    );

    final newAudioFile = File('${directory.path}/response.mp3');
    await audioFile.copy(newAudioFile.path);

    await audioPlayer.setSource(
      DeviceFileSource(newAudioFile.path),
    );
    await audioPlayer.play(UrlSource(newAudioFile.path));

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _messages.removeLast();
        _messages.add('GPT: $response');
      });
    });
  }

  Future<String?> _getGptResponse(String message) async {
    // A mensagem do usuário a ser enviada para a solicitação.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(message),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // A instrução a ser enviada para a solicitação.
    final instructionMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "Você é um assistente virtual de um aplicativo de receitas português; Seu nome é Tuga; Esse aplicativo é do canal Tuga na Cozinha, um canal de receitas português no youtube; Dever ser amigável e tratar apenas de assuntos relacionados a alimentação, culinária, receitas e nutrição; Sempre que tratar de nutrição, ressalte a importancia de procurar um profissional; Quando o utilizador tentar tratar de algum assunto que não seja um dos que mencionei, você deve se desculpar e informar que foi treinado apenas para ajudar em dúvidas sobre receitas e alimentação."),
      ],
      role: OpenAIChatMessageRole.system,
    );

    // A solicitação a ser enviada.
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        instructionMessage,
        userMessage,
      ],
      seed: 423,
      n: 2,
    );
    print(chatCompletion.choices.first.message);
    // Retorna apenas o texto da primeira resposta do GPT.
    return chatCompletion.choices.first.message.content?.first.text;
  }

  Future<File> _getGptAudioResponse(String message) async {
    final directory = await getApplicationDocumentsDirectory();
    final speechOutputDirectory = Directory('${directory.path}/speechOutput');
    if (!await speechOutputDirectory.exists()) {
      await speechOutputDirectory.create();
    }
    return await OpenAI.instance.audio.createSpeech(
      model: "tts-1",
      input: message,
      voice: "echo",
      responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
      outputDirectory: speechOutputDirectory,
      outputFileName: "response",
    );
  }
}
