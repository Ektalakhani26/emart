// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BrandAmbassador extends StatefulWidget {
  const BrandAmbassador({Key? key}) : super(key: key);

  @override
  State<BrandAmbassador> createState() => _BrandAmbassadorState();
}

class _BrandAmbassadorState extends State<BrandAmbassador> {
  PageController controller = PageController(initialPage: 0);

  List<String> videoIds = [
    'uUDO9z9VBi8',
    'uUDO9z9VBi8',
    'uUDO9z9VBi8',
    // Add more video IDs as needed
  ];

  List<Widget> videoPlayers = [];

  @override
  void initState() {
    super.initState();
    for (String videoId in videoIds) {
      YoutubePlayerController playerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          isLive: false,
          forceHD: true,
          disableDragSeek: true,
        ),
      );
      videoPlayers.add(YoutubePlayer(
        controller: playerController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brand Ambassador"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: controller,
            children: videoPlayers,
          ),
        ),
      ),
    );
  }
}
