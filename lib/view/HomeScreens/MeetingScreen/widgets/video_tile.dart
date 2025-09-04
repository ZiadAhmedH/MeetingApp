import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart' as rtc; // for RTCVideoView & Stream

class VideoTile extends StatelessWidget {
  final rtc.Stream stream;
  final String? name;
  const VideoTile({super.key, required this.stream,required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          rtc.RTCVideoView(
            stream.renderer!,
            objectFit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),

          if (name != null && name!.isNotEmpty)
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black54,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  name!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
