import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/users_view.dart';
import 'package:meta/meta.dart';
import '../../../view/HomeScreens/HomeSections/MainHomeSection.dart';


part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  static NavigationCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List pages = [const MainHomeSection(),  AllUsersView(), ];


  void changeIndex(int index) {
    currentIndex = index;
    emit(NavigationChangeIndexState());
  }
  
  void changeNavigation(){
    emit(NavigationChanged());
  }



}
