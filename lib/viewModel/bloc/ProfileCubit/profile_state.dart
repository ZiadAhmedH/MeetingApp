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
