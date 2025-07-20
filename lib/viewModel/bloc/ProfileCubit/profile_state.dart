part of 'profile_cubit.dart';


@immutable
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial States
class ProfileInitial extends ProfileState {}

class ImagePickerInitial extends ProfileState {}
class ImagePickerLoading extends ProfileState {}

class ImagePickerSuccess extends ProfileState {
  final XFile image;
  ImagePickerSuccess(this.image);

  @override
  List<Object?> get props => [image];
}

class ImagePickerError extends ProfileState {
  final String message;
  ImagePickerError(this.message);

  @override
  List<Object?> get props => [message];
}

// Status States
class UploadImageSuccess extends ProfileState {
  final String imageUrl;
  UploadImageSuccess(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class ChangingStatusState extends ProfileState {}

// Country States
class CountryLoading extends ProfileState {}

class CountrySuccess extends ProfileState {
  final String country;
  CountrySuccess(this.country);

  @override
  List<Object?> get props => [country];
}

class CountryError extends ProfileState {
  final String message;
  CountryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Terms State
class AcceptTermsState extends ProfileState {
  final bool isAcceptTerms;
  AcceptTermsState(this.isAcceptTerms);

  @override
  List<Object?> get props => [isAcceptTerms];
}

// Profile Information States
class LoadingUserInfoState extends ProfileState {}

class SuccessUserInfoState extends ProfileState {
  final UserModel user;
  SuccessUserInfoState(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;
  ProfileImageUpdated(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class UpdatingUserInfoState extends ProfileState {}

class UserInfoUpdatedSuccessfully extends ProfileState {}

class UserInfoUpdateError extends ProfileState {
  final String message;
  UserInfoUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

// User Loading States
class UsersLoading extends ProfileState {}

class UsersLoaded extends ProfileState {
  final List<UserModel> users;
  UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersLoadError extends ProfileState {
  final String message;
  UsersLoadError(this.message);

  @override
  List<Object?> get props => [message];
}

// Search States
class SearchLoading extends ProfileState {}

class SearchSuccess extends ProfileState {
  final List<UserModel> users;
  final Map<String, String> friendStatuses; // friend_id -> status

  SearchSuccess(this.users, {required this.friendStatuses});

  @override
  List<Object?> get props => [users, friendStatuses];
}

class SearchError extends ProfileState {
  final String message;
  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

// Friend Request States
class FriendRequestLoading extends ProfileState {}

class FriendRequestSent extends ProfileState {
  final String friendId;
  FriendRequestSent(this.friendId);

  @override
  List<Object?> get props => [friendId];
}

class FriendRequestError extends ProfileState {
  final String message;
  FriendRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

class FriendRequestsLoading extends ProfileState {}

class FriendRequestsLoaded extends ProfileState {
  final List<Map<String, dynamic>> requests;
  FriendRequestsLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

class FriendUpdated extends ProfileState {}


class FriendRequestPendingCount extends ProfileState {
  final int count;
  FriendRequestPendingCount(this.count);

  @override
  List<Object?> get props => [count];
}