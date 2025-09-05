
  import 'package:flutter/material.dart';

Widget ParticipantList( Map<String, dynamic> _participants, dynamic _room) {
    final items = _participants.values.map((p) {
      final isLocal = p.id == _room?.localParticipant.id;
      return ListTile(
        leading: const Icon(Icons.person),
        title: Text(
          p.displayName + (isLocal ? " (You)" : ""),
          style: TextStyle(
            fontWeight: isLocal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }).toList();

    return ListView(children: items);
  }
