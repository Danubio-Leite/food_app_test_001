import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.vimeo(
        '942732913',
      ),
      podPlayerConfig: const PodPlayerConfig(
          autoPlay: false, isLooping: false, videoQualityPriority: [720, 360]),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Receita de Alho',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: PodVideoPlayer(
                  controller: controller,
                  // videoThumbnail: const DecorationImage(
                  //   image: NetworkImage(
                  //     'https://s2.glbimg.com/zY32MQou7CFi7sLKNida7Ii2rUU=/e.glbimg.com/og/ed/f/original/2016/07/12/alho.jpg',
                  //   ),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Corte o alho em pedaços pequenos e frite com azeite',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
