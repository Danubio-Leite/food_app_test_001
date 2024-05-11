import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pod_player/pod_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  ValueNotifier<bool> isInitialising = ValueNotifier(false);
  ValueNotifier<PodPlayerController?> controllerNotifier = ValueNotifier(null);
  int currentStep = 0;
  List<String> videoCodes = ['944801954', '944802967'];

  List<String> stepTexts = [
    'Cozinhe o bimi no vapor por 5 minutos.',
    'Tempere o bimi com o que tiver a mão.'
  ];
  List<String> stepVoice = [
    'O bimi pode até se consumido cru, mas cozinhando por cinco minutos encontramos o ponto ideal mantendo a crocancia e conseguindo ressaltar seu sabor.',
    'Miguel, agora é a hora de temperar o bimi. Use o que tiver a mão, seja sal, pimenta, azeite, limão, ou até mesmo um molho de sua preferência. O importante é que você sinta prazer ao degustar essa delícia.'
  ];

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initController();
    // speak_flutter_tts();
  }

  void initController() {
    controllerNotifier.value?.dispose();
    controllerNotifier.value = PodPlayerController(
      playVideoFrom: PlayVideoFrom.vimeo(
        videoCodes[currentStep],
      ),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: true,
        isLooping: true,
        videoQualityPriority: [720, 360],
      ),
    )..initialise();
  }

  // Future<void> speak_flutter_tts() async {
  //   // List ttsVoices = await flutterTts.getVoices;
  //   // var availableVoices =
  //   //     ttsVoices.cast<Map>().map((e) => e.cast<String, String>()).toList();
  //   await flutterTts.setPitch(0.8);
  //   await flutterTts.setSpeechRate(0.4);
  //   await flutterTts.setLanguage('pt-PT');
  //   // print(availableVoices
  //   //     .firstWhere((element) => element['locale']!.contains('pt-BR')));
  //   // await flutterTts.setVoice(availableVoices[12]);

  //   await flutterTts.speak(stepVoice[currentStep]);
  // }

  // Future<void> speak_azure() async {
  //   // Inicialize o AzureTts com suas credenciais
  //   AzureTts.init(
  //       subscriptionKey: 'ec6500ba76e94145b579727d2695c75b',
  //       region: 'brazilsouth',
  //       withLogs: true);

  //   // Obtenha as vozes disponíveis
  //   final voicesResponse = await AzureTts.getAvailableVoices();

  //   // Escolha uma voz em português
  //   final voice =
  //       voicesResponse.voices.firstWhere((v) => v.locale.startsWith('pt-'));

  //   // Gere o áudio para um texto
  //   TtsParams params = TtsParams(
  //       voice: voice,
  //       audioFormat: AudioOutputFormat.audio16khz32kBitrateMonoMp3,
  //       text: stepVoice[currentStep]);

  //   final ttsResponse = await AzureTts.getTts(params);

  //   // Obtenha os bytes de áudio
  //   final audioBytes = ttsResponse.audio.buffer.asUint8List();

  //   // Salve o áudio em um arquivo local
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   String path = '$dir/audio.mp3';
  //   File audioFile = File(path);
  //   await audioFile.writeAsBytes(audioBytes);

  //   // Reproduza o áudio
  //   AudioPlayer audioPlayer = AudioPlayer();
  //   await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(path)));
  //   await audioPlayer.play();
  // }

  @override
  void dispose() {
    controllerNotifier.value?.dispose();
    super.dispose();
  
  }

  A VERSAO DO POD_PLAYER ESTÁ DESATUALIZADA, NÃO FUNCIONA 

  Future<void> nextStep() async {
    if (currentStep < videoCodes.length - 1) {
      currentStep++;
      isInitialising.value = true;
      var oldController = controllerNotifier.value;
      controllerNotifier.value = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(
          videoCodes[currentStep],
        ),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
          isLooping: true,
          videoQualityPriority: [720, 360],
        ),
      );
      await controllerNotifier.value!.initialise();
      oldController?.dispose();
      isInitialising.value = false;
      setState(() {});
      // await flutterTts.setPitch(0.8);
      // await flutterTts.setSpeechRate(0.4);
      // await flutterTts.setLanguage('pt-PT');
      // speak_flutter_tts();
      // speak_azure();
    }
  }

  Future<void> previousStep() async {
    if (currentStep > 0) {
      currentStep--;
      isInitialising.value = true;
      var oldController = controllerNotifier.value;
      controllerNotifier.value = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(
          videoCodes[currentStep],
        ),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
          isLooping: true,
          videoQualityPriority: [720, 360],
        ),
      );
      await controllerNotifier.value!.initialise();
      oldController?.dispose();
      isInitialising.value = false;
      setState(() {});
      // await flutterTts.setPitch(0.8);
      // await flutterTts.setSpeechRate(0.4);
      // await flutterTts.setLanguage('pt-PT');
      // speak_flutter_tts();
      // speak_azure();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Bimi no vapor',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ValueListenableBuilder<PodPlayerController?>(
                valueListenable: controllerNotifier,
                builder: (context, controller, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isInitialising,
                    builder: (context, isInitialising, child) {
                      if (!isInitialising) {
                        return PodVideoPlayer(
                          overlayBuilder: (OverLayOptions options) {
                            return Container(
                              color: Colors.black.withOpacity(0.0),
                              child: Center(
                                child: controllerNotifier.value!.isInitialised
                                    ? const SizedBox()
                                    : const Text('Carregando...'),
                              ),
                            );
                          },
                          controller: controller!,
                          videoThumbnail: const DecorationImage(
                            image: NetworkImage(
                              'https://www.noticiasmagazine.pt/files/2018/04/shutterstock_636478175.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          alwaysShowProgressBar: false,
                          onVideoError: () {
                            return const Center(
                              child: Text(
                                'Erro ao carregar o vídeo.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text('Carregando...');
                      }
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              stepTexts[currentStep],
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: previousStep,
                child: const Text('Passo anterior'),
              ),
              ElevatedButton(
                onPressed: nextStep,
                child: const Text('Próximo passo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
