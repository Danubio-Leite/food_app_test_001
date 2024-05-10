import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    initController();
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

  @override
  void dispose() {
    controllerNotifier.value?.dispose();
    super.dispose();
  }

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
