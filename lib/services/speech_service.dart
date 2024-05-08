import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  String _status = '';
  final List<String> _lastWords = [];
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
    'laranja'
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
      print('Iniciando a escuta...'); // Adicionado para depuração
      PermissionStatus permissionStatus = await Permission.microphone.status;

      if (permissionStatus.isDenied) {
        print(
            'Permissão de microfone negada. Solicitando permissão...'); // Adicionado para depuração
        permissionStatus = await Permission.microphone.request();
      }

      if (permissionStatus.isGranted) {
        print('Permissão de microfone concedida.'); // Adicionado para depuração
        if (!_isListening) {
          print(
              'Inicializando o serviço de fala...'); // Adicionado para depuração
          bool available = await _speech.initialize(
            onStatus: (val) {
              print(
                  'Status do serviço de fala: $val'); // Adicionado para depuração
              if (val == 'done' && _status != 'error_busy') {
                _status = val;
                _isListening = false;
                // listen(onResultCallback);
              }
            },
            onError: (val) {
              print(
                  'Erro do serviço de fala: $val'); // Adicionado para depuração
              _status = val.toString();
            },
          );
          if (available) {
            print(
                'Serviço de fala disponível. Iniciando a escuta...'); // Adicionado para depuração
            _isListening = true;
            _speech.listen(
              onResult: (val) {
                _text = val.recognizedWords;
                print(
                    'Palavras reconhecidas: $_text'); // Adicionado para depuração
                if (_colorNames.contains(_text.toLowerCase())) {
                  _containerColor = _getColorFromName(_text.toLowerCase());
                }
                if (_lastWords.length == 3) {
                  _lastWords.removeAt(0);
                }
                _lastWords.add(_text);
                onResultCallback();
              },
              listenFor: const Duration(seconds: 10),
            );
          } else {
            _status = 'O serviço de fala não está disponível';
          }
        } else {
          print('Parando a escuta...'); // Adicionado para depuração
          _isListening = false;
          await _speech.stop();
        }
      } else {
        if (permissionStatus.isPermanentlyDenied) {
          print(
              'Permissão de microfone permanentemente negada. Abrindo configurações do aplicativo...'); // Adicionado para depuração
          openAppSettings();
        } else {
          _status = 'Permissão de microfone negada';
        }
      }
    } catch (e) {
      print('Erro: ${e.toString()}'); // Adicionado para depuração
      _status = 'Erro: ${e.toString()}';
    }
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
