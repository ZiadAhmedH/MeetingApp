part of 'verfiy_cubit.dart';

@immutable
abstract class VerfiyState {}

class VerfiyInitial extends VerfiyState {}




class LoadingVerfiyState extends VerfiyState {}
class VerfiySuccessState extends VerfiyState {}
class VerfiyErrorState extends VerfiyState {
  final String error;
  VerfiyErrorState(this.error);
}
