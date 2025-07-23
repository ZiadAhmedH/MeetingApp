import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/users_view.dart';
import 'package:meeting_app/view/searchView/search_view.dart';
import 'package:meta/meta.dart';
import '../../../view/HomeScreens/HomeSections/MainHomeSection.dart';


part 'navigation_state.dart';
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  static NavigationCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  final PageController pageController = PageController();

  List<Widget> pages = [
    const MainHomeSection(),
    const SearchView(),
    UsersView(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    pageController.jumpToPage(index);
    emit(NavigationChangeIndexState());
  }

  void onPageChanged(int index) {
    currentIndex = index;
    emit(NavigationPageChangeIndexState());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
