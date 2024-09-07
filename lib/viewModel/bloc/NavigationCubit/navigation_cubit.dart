import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/views/HomeScreens/ProfileScreen/ProfileScreen.dart';
import 'package:meta/meta.dart';

import '../../../views/HomeScreens/ChatScreen/ChatScreen.dart';
import '../../../views/HomeScreens/HomeSections/MainHomeSection.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  static NavigationCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List pages = [const MainHomeSection(), const ChatScreen(), const ProfileScreen()];


  void changeIndex(int index) {
    currentIndex = index;
    emit(NavigationChangeIndexState());
  }
  void changeNavigation(){
    emit(NavigationChanged());
  }



}
