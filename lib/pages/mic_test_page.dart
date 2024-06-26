import 'package:flutter/material.dart';
import '../services/speech_service.dart';

class MicPage extends StatefulWidget {
  const MicPage({super.key});

  @override
  _MicPageState createState() => _MicPageState();
}

class _MicPageState extends State<MicPage> {
  late SpeechService _speechService;
  bool _isListening = false;
  String _status = '';
  List<String> _lastWords = [];
  Color _containerColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
    _listen();
  }

  void _listen() async {
    try {
      await _speechService.listen(() {
        setState(() {
          _isListening = _speechService.isListening;
          _status = _speechService.status;
          _containerColor = _speechService.containerColor;
          _lastWords = _speechService.lastWords;
        });
      });
      setState(() {
        _isListening = _speechService.isListening;
      });
    } catch (e) {
      print('Erro ao iniciar a escuta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Center(
                child: Text(
                  'Cores disponíveis: Azul, Verde, Vermelho, Amarelo, Branco, Preto, Cinza, Marrom, Roxo, Rosa, Laranja',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Icon(
                Icons.mic,
                size: 100,
                color: Colors.grey,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: _containerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 250,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'últimas palavras: ${_lastWords.join(', ')}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  )),
              ElevatedButton(
                onPressed: _listen,
                child: Text(
                  _isListening ? 'Off' : 'On',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 88, 88, 88),
                  ),
                ),
              ),
              Text('status: $_status'),
            ],
          ),
        ),
      ),
    );
  }
}
