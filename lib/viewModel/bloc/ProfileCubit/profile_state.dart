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


// Status

class UploadImageSuccess extends ProfileState {
  final String imageUrl;
  UploadImageSuccess(this.imageUrl);
}



class ChangingStatusState extends ProfileState {}


// Country
class CountryLoading extends ProfileState {}
class CountrySuccess extends ProfileState {
  final String country;
  CountrySuccess(this.country);
}
class CountryError extends ProfileState {
  final String message;
  CountryError(this.message);
}

// terms
class AcceptTermsState extends ProfileState {
  final bool isAcceptTerms;
  AcceptTermsState(this.isAcceptTerms);
}

// Profile
class LoadingUserInfoState extends ProfileState {}
class SuccessUserInfoState extends ProfileState {
  final UserModel user;
  SuccessUserInfoState(this.user);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);

}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;
  ProfileImageUpdated(this.imageUrl);
}

class UpdatingUserInfoState extends ProfileState {}

class UserInfoUpdatedSuccessfully extends ProfileState {}
class UserInfoUpdateError extends ProfileState {
  final String message;
  UserInfoUpdateError(this.message);
}

class UsersLoading extends ProfileState {}

class UsersLoaded extends ProfileState {
  final List<UserModel> users;
  UsersLoaded(this.users);
}

class UsersLoadError extends ProfileState {
  final String message;
  UsersLoadError(this.message);
}

// search
class SearchLoading extends ProfileState {}

class SearchSuccess extends ProfileState {
  final List<UserModel> users;
  final Map<String, String> friendStatuses; // friend_id -> status

  SearchSuccess(this.users, {required this.friendStatuses});
}

class SearchError extends ProfileState {
  final String message;
  SearchError(this.message);
}





class FriendRequestLoading extends ProfileState {}

class FriendRequestSent extends ProfileState {
  final String friendId;
  FriendRequestSent(this.friendId);
}

class FriendRequestError extends ProfileState {
  final String message;
  FriendRequestError(this.message);
}

