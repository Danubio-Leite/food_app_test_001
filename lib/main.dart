import 'package:flutter/material.dart';
import 'package:food_app_test_001/app.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _checkAndRequestPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Future<void> _checkAndRequestPermission() async {
    // Verifica e solicita a permissão do microfone
    PermissionStatus microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      await Permission.microphone.request();
    }

    // Verifica e solicita a permissão de reconhecimento de voz
    PermissionStatus speechStatus = await Permission.speech.status;
    if (!speechStatus.isGranted) {
      await Permission.speech.request();
    }

    // Verifica novamente o status das permissões
    microphoneStatus = await Permission.microphone.status;
    speechStatus = await Permission.speech.status;

    if (microphoneStatus.isPermanentlyDenied ||
        speechStatus.isPermanentlyDenied) {
      print('Uma ou ambas as permissões foram negadas permanentemente.');
    } else if (microphoneStatus.isGranted && speechStatus.isGranted) {
      print('Ambas as permissões foram concedidas.');
    } else if (microphoneStatus.isRestricted || speechStatus.isRestricted) {
      print('Uma ou ambas as permissões são restritas.');
    } else if (microphoneStatus.isLimited || speechStatus.isLimited) {
      print('Uma ou ambas as permissões são limitadas.');
    } else {
      print('Uma ou ambas as permissões ainda não foram concedidas.');
    }
  }
}
