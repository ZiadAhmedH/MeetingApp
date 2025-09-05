import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart' as rtc;

List<Widget> videoTiles( Map<String, dynamic> participants, Map<String, dynamic> _videoStreams) {
  return participants.entries.map((entry) {
    final participant = entry.value;
    final stream = _videoStreams[entry.key];

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: stream != null
                ? rtc.RTCVideoView(
                    stream.renderer!,
                    objectFit:
                        rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : Container(
                    color: Colors.grey.shade900,
                    child: Center(
                      child: Text(
                        participant.displayName.isNotEmpty
                            ? participant.displayName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              participant.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }).toList();
}