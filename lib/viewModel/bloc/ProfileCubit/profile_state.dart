part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}


class ImagePickerInitial extends ProfileState {}

class ImagePickerLoading extends ProfileState {}

class ImagePickerSuccess extends ProfileState {
  final XFile image;

  ImagePickerSuccess(this.image);
}

class ImagePickerError extends ProfileState {
  final String message;

  ImagePickerError(this.message);
}



class ChangingStatusState extends ProfileState {}



class CountryLoading extends ProfileState {}
class CountrySuccess extends ProfileState {
  final String country;
  CountrySuccess(this.country);
}
class CountryError extends ProfileState {
  final String message;
  CountryError(this.message);
}


class AcceptTermsState extends ProfileState {
  final bool isAcceptTerms;
  AcceptTermsState(this.isAcceptTerms);
}
