import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicPage extends StatefulWidget {
  const MicPage({super.key});

  @override
  _MicPageState createState() => _MicPageState();
}

class _MicPageState extends State<MicPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  List<String> _colorNames = [
    'azul',
    'verde',
    'vermelho',
    'amarelo',
    'branco',
    'preto',
    'cinza',
    'marrom',
    'roxo',
    'rosa',
    'laranja'
  ];
  List<String> _lastWords = [];
  Color _containerColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    print('Checking microphone permission...');
    PermissionStatus permissionStatus = await Permission.microphone.status;

    if (permissionStatus.isDenied) {
      print('Microphone permission is denied. Requesting permission...');
      permissionStatus = await Permission.microphone.request();
    }

    if (permissionStatus.isGranted) {
      print('Microphone permission is granted.');
      if (!_isListening) {
        print('Initializing speech to text...');
        bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
        );
        if (available) {
          print('Speech to text is available. Starting to listen...');
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) {
              setState(() {
                _text = val.recognizedWords;
                if (_colorNames.contains(_text.toLowerCase())) {
                  _containerColor = _getColorFromName(_text.toLowerCase());
                }
                if (_lastWords.length == 3) {
                  _lastWords.removeAt(0);
                }
                _lastWords.add(_text);
              });
            },
          );
        } else {
          print('Speech to text is not available.');
        }
      } else {
        print('Stopping to listen...');
        setState(() => _isListening = false);
        _speech.stop();
      }
    } else {
      print('Microphone permission was denied.');
      if (permissionStatus.isPermanentlyDenied) {
        print(
            'Microphone permission is permanently denied. Opening app settings...');
        openAppSettings();
      }
    }
  }

  Color _getColorFromName(String name) {
    switch (name) {
      case 'azul':
        return Colors.blue;
      case 'verde':
        return Colors.green;
      case 'vermelho':
        return Colors.red;
      case 'amarelo':
        return Colors.yellow;
      case 'branco':
        return Colors.white;
      case 'preto':
        return Colors.black;
      case 'cinza':
        return Colors.grey;
      case 'marrom':
        return Colors.brown;
      case 'roxo':
        return Colors.purple;
      case 'rosa':
        return Colors.pink;
      case 'laranja':
        return Colors.orange;
      default:
        return Colors.blue;
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
