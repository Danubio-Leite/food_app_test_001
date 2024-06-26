import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  String _status = '';
  List<String> _lastWords = [];
  final List<String> _colorNames = [
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
    'laranja',
    'blue',
    'green',
    'red',
    'yellow',
    'white',
    'black',
    'gray',
    'brown',
    'purple',
    'pink',
    'orange'
  ];
  Color _containerColor = Colors.blue;

  bool get isListening => _isListening;
  String get text => _text;
  String get status => _status;
  List<String> get lastWords => _lastWords;
  Color get containerColor => _containerColor;

  Future<void> stop() async {
    _isListening = false;
    await _speech.stop();
  }

  Future<void> listen(Function onResultCallback) async {
    try {
      print('Iniciando a escuta...');
      PermissionStatus permissionStatus = await Permission.microphone.status;

      if (permissionStatus.isDenied) {
        print('Permissão de microfone negada. Solicitando permissão...');
      }

      if (permissionStatus.isGranted) {
        print('Permissão de microfone concedida.');
        if (!_isListening) {
          print('Inicializando o serviço de fala...');
          bool available = await _speech.initialize(
            onStatus: (val) {
              print('Status do serviço de fala: $val');
              if (val == 'done' && _status != 'error_busy') {
                _status = val;
                _isListening = false;
              }
            },
            onError: (val) {
              print('Erro do serviço de fala: $val');
              _status = val.toString();
            },
          );
          if (available) {
            print('Serviço de fala disponível. Iniciando a escuta...');
            _isListening = true;
            _startListening(onResultCallback);
          } else {
            _status = 'O serviço de fala não está disponível';
          }
        } else {
          print('Parando a escuta...');
          _isListening = false;
          await _speech.stop();
        }
      } else {
        if (permissionStatus.isPermanentlyDenied) {
          print(
              'Permissão de microfone permanentemente negada. Abrindo configurações do aplicativo...');
          openAppSettings();
        } else {
          _status = 'Permissão de microfone negada';
        }
      }
    } catch (e) {
      print('Erro: ${e.toString()}');
      _status = 'Erro: ${e.toString()}';
    }
  }

  void _startListening(Function onResultCallback) {
    _speech.listen(
      onResult: (val) {
        _text = val.recognizedWords;
        List<String> words = _text.split(' ');
        for (String word in words) {
          if (_colorNames.contains(word.toLowerCase())) {
            _containerColor = _getColorFromName(word.toLowerCase());
          }
        }
        if (_lastWords.length == 3) {
          _lastWords.removeAt(0);
        }
        String lastWord = words.last;
        _lastWords.add(lastWord);
        print('Últimas palavras: $_lastWords');
        onResultCallback();
      },
      listenFor: const Duration(seconds: 30),
    );

    _speech.statusListener = (val) {
      if (val == 'done' && _isListening) {
        _startListening(onResultCallback);
      }
    };
  }

  Color _getColorFromName(String name) {
    switch (name) {
      case 'azul':
      case 'blue':
        return Colors.blue;
      case 'verde':
      case 'green':
        return Colors.green;
      case 'vermelho':
      case 'red':
        return Colors.red;
      case 'amarelo':
      case 'yellow':
        return Colors.yellow;
      case 'branco':
      case 'white':
        return Colors.white;
      case 'preto':
      case 'black':
        return Colors.black;
      case 'cinza':
      case 'gray':
        return Colors.grey;
      case 'marrom':
      case 'brown':
        return Colors.brown;
      case 'roxo':
      case 'purple':
        return Colors.purple;
      case 'rosa':
      case 'pink':
        return Colors.pink;
      case 'laranja':
      case 'orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
