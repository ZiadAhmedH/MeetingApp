import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingInitial());
  static MeetingCubit get(context) => BlocProvider.of(context);


  final navigatorKey = GlobalKey<NavigatorState>();

  String meetingId = '';

  void createMeeting() {


  }


  void generateRandomId() {
    final random = Random();
    meetingId =  '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}';

    emit(MeetingGeneratedIdState());
  }





}
