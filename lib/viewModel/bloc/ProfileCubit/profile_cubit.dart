// 📁 Updated ProfileCubit with Realtime Friends & Friend Request Logic
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../model/Models/UserModel.dart';
import '../../data/SharedKeys.dart';
import '../../data/SharedPrefrences.dart';
import '../CommonFunction.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> implements CommonFun {
  ProfileCubit() : super(ProfileInitial());

  final Dio dio = Dio();
  static ProfileCubit get(context) => BlocProvider.of(context);

  XFile? image;
  final ImagePicker _picker = ImagePicker();

  static String countryName = '';
  UserModel? User;

  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  static TextEditingController userLocation = TextEditingController();
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();
  static TextEditingController jobtitle = TextEditingController();

  @override
  bool isAcceptTerms = false;
  bool isOnline = false;
  static String currentStatus = 'Software Engineer';

  List<String> jobTitle = [
    'Software Engineer', 'Doctor', 'Nurse', 'Teacher', 'Student', 'Businessman', 'Others'
  ];

  final supabase = Supabase.instance.client;
  RealtimeChannel? _friendSubscription;
  List<Map<String, dynamic>> pendingRequests = [];


  Future<void> pickImageFromGallery({required String uid, required String email}) async {
    emit(ImagePickerLoading());
    try {
      final photosPermission = await Permission.photos.request();
      final storagePermission = await Permission.storage.request();

      if (photosPermission.isGranted || storagePermission.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          image = pickedFile;
          emit(ImagePickerSuccess(pickedFile));
        } else {
          emit(ImagePickerError('No image selected.'));
        }
      } else if (photosPermission.isPermanentlyDenied || storagePermission.isPermanentlyDenied) {
        await openAppSettings();
        emit(ImagePickerError('Permission permanently denied. Please enable it in app settings.'));
      } else {
        emit(ImagePickerError('Gallery permission is required to pick images.'));
      }
    } catch (e) {
      emit(ImagePickerError('Failed to pick image: $e'));
    }
  }

  Future<void> getUserInfo() async {
    emit(LoadingUserInfoState());
    try {
      final data = await supabase.from("users").select().eq('id', LocalData.getData(key: SharedKey.uid)).single();
      User = UserModel.fromJson(data);
      firstName.text = User!.userName.split(' ')[0];
      lastName.text = User!.userName.split(' ')[1];
      userLocation.text = User!.location;
      currentStatus = User!.jobTitle;
      jobtitle.text = User!.jobTitle;
      emit(SuccessUserInfoState(User!));
    } catch (e) {
      emit(ProfileError('Failed to fetch user info: $e'));
    }
  }

  Future<void> uploadPImage({required XFile image, required String email, required String uid}) async {
    final imagePath = 'ProfileImage/$email/${image.path.split('/').last}';
    try {
      final file = File(image.path);
      await supabase.storage.from('avatars').upload(imagePath, file, fileOptions: FileOptions(cacheControl: '3600', upsert: true));
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(imagePath);
      await supabase.from('users').update({'profile_image': publicUrl}).eq('id', uid);
    } catch (e) {
      print('❌ Error uploading profile image: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserMeetings() async {
    try {
      final response = await supabase.from('meetings').select().eq('host_id', LocalData.getData(key: SharedKey.uid));
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  void changingJobTitle(String value) {
    currentStatus = value;
    emit(ChangingStatusState());
  }

  Future<void> getCountry() async {
    emit(CountryLoading());
    try {
      final ipResponse = await dio.get('https://api64.ipify.org?format=json');
      final ip = ipResponse.data['ip'];
      final countryResponse = await dio.get('https://ipinfo.io/$ip/json');
      final country = countryResponse.data['timezone'];
      countryName = country;
      userLocation.text = countryName;
      emit(CountrySuccess(country));
    } catch (e) {
      emit(CountryError('Failed to get country: $e'));
    }
  }

  Future<void> updateUserInfo({required String username, required String uid, required String location}) async {
  emit(UpdatingUserInfoState());
  try {
    await supabase.from('users').update({
      'username': username,
      'profile_image': User!.profileImage,
      'location': location,
    }).eq('id', uid);

    if (image != null) {
      await uploadPImage(image: image!, email: LocalData.getData(key: SharedKey.email), uid: uid);
    }
    await getUserInfo();
    emit(UserInfoUpdatedSuccessfully());
  } catch (e) {
    emit(UserInfoUpdateError('Failed to update user info: $e'));
  }
}


  bool hasChanges() {
    final currentFullName = "${firstName.text.trim()} ${lastName.text.trim()}";
    final storedFullName = User?.userName.trim();
    final currentLocation = userLocation.text.trim();
    final storedLocation = User?.location.trim();
    return currentFullName != storedFullName || currentLocation != storedLocation || image != null;
  }

  Future<void> searchUser(String query) async {
    emit(SearchLoading());
    final myId = LocalData.getData(key: SharedKey.uid);
    try {
      final response = await supabase.from('users').select().ilike('username', '%$query%').not('id', 'eq', myId);
      final users = (response as List).map((e) => UserModel.fromJson(e)).toList();
      final friendRes = await supabase.from('friends').select().or('user_id.eq.$myId,friend_id.eq.$myId');
      final Map<String, String> friendStatuses = {};
      for (var friend in friendRes) {
        final uid = friend['user_id'];
        final fid = friend['friend_id'];
        final status = friend['status'];
        final otherId = uid == myId ? fid : uid;
        friendStatuses[otherId] = status;
      }
      emit(SearchSuccess(users, friendStatuses: friendStatuses));
    } catch (e) {
      emit(SearchError("Failed to search users: $e"));
    }
  }

  Future<void> loadAllUsers() async {
    emit(UsersLoading());
    try {
      final myUid = LocalData.getData(key: SharedKey.uid);
      final res = await supabase.from('users').select('*').not('id', 'eq', myUid);
      final fetchedUsers = (res as List).map((e) => UserModel.fromJson(e)).toList();
      emit(UsersLoaded(fetchedUsers));
    } catch (e) {
      emit(UsersLoadError('Failed to load users: $e'));
    }
  }

  Future<void> addFriend(String friendId) async {
  final myId = LocalData.getData(key: SharedKey.uid);
  if (myId == null || myId == friendId) return;

  final currentState = state;
  if (currentState is! SearchSuccess) {
    emit(FriendRequestError('You can only add friends from search results'));
    return;
  }

  emit(FriendRequestLoading());

  try {
    await supabase.from('friends').insert({
      'user_id': myId,
      'friend_id': friendId,
      'status': 'pending',
    });

    final updatedStatuses = Map<String, String>.from(currentState.friendStatuses);
    updatedStatuses[friendId] = 'pending';
    emit(SearchSuccess(currentState.users, friendStatuses: updatedStatuses));
  } catch (e) {
    emit(FriendRequestError('Unexpected error: $e'));
  }
}

  
  
  Future<void> loadPendingFriendRequests() async {
  emit(FriendRequestsLoading());
  final myId = LocalData.getData(key: SharedKey.uid);

  try {
    final response = await supabase
        .from('friends')
        .select('*, user:users!friends_user_id_fkey(*)')
        .eq('friend_id', myId)
        .eq('status', 'pending');

    final data = (response as List).map((e) => Map<String, dynamic>.from(e)).toList();

    pendingRequests = data;
    emit(FriendRequestsLoaded(pendingRequests));
  } catch (e) {
    print('❌ Error loading pending friend requests: $e');
    emit(ProfileError('Failed to load friend requests: $e'));
  }
}




void listenToFriendRealtime(String myId) {
  _friendSubscription = supabase.channel('public:friends');

  _friendSubscription!
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'friends',
        callback: (payload) {
          final newData = payload.newRecord;
          final oldData = payload.oldRecord;

          if ((newData != null &&
                  (newData['user_id'] == myId || newData['friend_id'] == myId)) ||
              (oldData != null &&
                  (oldData['user_id'] == myId || oldData['friend_id'] == myId))) {
            emit(FriendUpdated());
          }
        },
      )
      .subscribe();
}


  void cancelFriendSubscription() {
    if (_friendSubscription != null) {
      supabase.removeChannel(_friendSubscription!);
      _friendSubscription = null;
    }
  }

 Future<void> acceptFriend(String requesterId) async {
  final myId = LocalData.getData(key: SharedKey.uid);

  try {
    await supabase
        .from('friends')
        .update({'status': 'accepted'})
        .eq('user_id', requesterId)
        .eq('friend_id', myId);

    loadPendingFriendRequests();
    emit(FriendUpdated());
  } catch (e) {
    emit(ProfileError('Failed to accept friend request: $e'));
  }
}

Future<void> rejectFriend(String requesterId) async {
  final myId = LocalData.getData(key: SharedKey.uid);

  try {
    await supabase
        .from('friends')
        .delete()
        .eq('user_id', requesterId)
        .eq('friend_id', myId);

    loadPendingFriendRequests();
    emit(FriendUpdated());
  } catch (e) {
    emit(ProfileError('Failed to reject friend request: $e'));
  }
}
  
  Stream<int> realtimeFriendRequestPendingCountStream() async* {
  final myId = LocalData.getData(key: SharedKey.uid);

  final controller = StreamController<int>(
    onCancel: () async {
      supabase.removeChannel(_friendSubscription!);
    },
  );

  // Initial count fetch
  final initialResponse = await supabase
      .from('friends')
      .select('user_id')
      .eq('friend_id', myId)
      .eq('status', 'pending');

  final initialCount = initialResponse.length;
  controller.add(initialCount);

  // Set up Supabase realtime listener
  final channel = supabase.channel('public:friends_count');

  channel.onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'friends',
    callback: (payload) async {
      final newData = payload.newRecord;
      final oldData = payload.oldRecord;

      final isRelevant = (newData != null && newData['friend_id'] == myId && newData['status'] == 'pending') ||
                         (oldData != null && oldData['friend_id'] == myId && oldData['status'] == 'pending');

      if (isRelevant) {
        final updatedResponse = await supabase
            .from('friends')
            .select('user_id')
            .eq('friend_id', myId)
            .eq('status', 'pending');

        final newCount = updatedResponse.length;
        controller.add(newCount);
      }
    },
  ).subscribe();

  _friendSubscription = channel;

  yield* controller.stream;
}

 

  @override
  void acceptTerms() {
    isAcceptTerms = !isAcceptTerms;
    emit(AcceptTermsState(isAcceptTerms));
  }

  void disposeController() {
    userLocation.dispose();
    firstName.dispose();
    lastName.dispose();
  }
}
