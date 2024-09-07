part of 'navigation_cubit.dart';

@immutable
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationChangeIndexState extends NavigationState {}


class NavigationChanged extends NavigationState {}