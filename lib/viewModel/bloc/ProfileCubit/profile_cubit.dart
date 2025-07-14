import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../model/Models/UserModel.dart';

import '../CommonFunction.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> implements CommonFun {
  ProfileCubit() : super(ProfileInitial());

  final Dio dio = Dio();
  static ProfileCubit get(context) => BlocProvider.of(context);

  // 📸 User Profile image
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  // 🌍 User country (detected via IP)
  static String countryName = '';

  // 👤 User model
  UserModel? User;

  // 📝 Form fields and validation
  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  static TextEditingController userLocation = TextEditingController();
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();
  static TextEditingController jobtitle = TextEditingController();

  // ✅ Terms acceptance toggle
  @override
  bool isAcceptTerms = false;

  // 🌐 Online presence state
  bool isOnline = false;

  // 🧠 Cached current job title
  static String currentStatus = 'Software Engineer';

  // 🔽 Dropdown options
  List<String> jobTitle = [
    'Software Engineer',
    'Doctor',
    'Nurse',
    'Teacher',
    'Student',
    'Businessman',
    'Others'
  ];

  final supabase = Supabase.instance.client;

  /// 📸 Picks image from gallery with permission checks
  Future<void> pickImageFromGallery({
    required String uid,
    required String email,
  }) async {
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
      } else if (photosPermission.isPermanentlyDenied ||
          storagePermission.isPermanentlyDenied) {
        await openAppSettings();
        emit(ImagePickerError(
            'Permission permanently denied. Please enable it in app settings.'));
      } else {
        emit(ImagePickerError('Gallery permission is required to pick images.'));
      }
    } catch (e) {
      emit(ImagePickerError('Failed to pick image: $e'));
    }
  }

  /// 👤 Loads user profile info from Supabase
  Future<void> getUserInfo() async {
    emit(LoadingUserInfoState());

    try {
      final data = await supabase
          .from("users")
          .select()
          .eq('id', LocalData.getData(key: SharedKey.uid))
          .single();

      User = UserModel.fromJson(data);

      // Splitting full name into first/last
      firstName.text = User!.userName.split(' ')[0];
      lastName.text = User!.userName.split(' ')[1];
      userLocation.text = User!.location;
      currentStatus = User!.jobTitle;
      jobtitle.text = User!.jobTitle;

      print('User Info: ${User!.toJson()}');

      emit(SuccessUserInfoState(User!));
    } catch (e) {
      print('Error fetching user info: $e');
      emit(ProfileError('Failed to fetch user info: $e'));
    }
  }

  /// 📤 Uploads profile image to Supabase Storage and updates user row
  Future<void> uploadPImage({
    required XFile image,
    required String email,
    required String uid,
  }) async {
    final imagePath = 'ProfileImage/$email/${image.path.split('/').last}';

    print("""
📸 Uploading profile image: $imagePath
User ID: $uid
Email: $email 
""");

    try {
      final file = File(image.path);

      await supabase.storage
          .from('avatars')
          .upload(imagePath, file, fileOptions: FileOptions(cacheControl: '3600', upsert: true));

      final publicUrl = supabase.storage.from('avatars').getPublicUrl(imagePath);

      print('✅ Image URL: $publicUrl');

      final updateRes = await supabase
          .from('users')
          .update({'profile_image': publicUrl})
          .eq('id', uid);

      print("🛠️ Update result: $updateRes");
    } catch (e) {
      print('❌ Error uploading profile image: $e');
    }
  }

  /// 📅 Get all meetings created by the user
  Future<List<Map<String, dynamic>>> getUserMeetings() async {
    try {
      final response = await supabase
          .from('meetings')
          .select()
          .eq('host_id', LocalData.getData(key: SharedKey.uid));

      if (response.isEmpty) {
        throw Exception('No meetings found for this user.');
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user meetings: $e');
      return [];
    }
  }

  /// 🔁 Updates current job title
  void changingJobTitle(String value) {
    currentStatus = value;
    emit(ChangingStatusState());
  }

  /// 🌍 Gets country using IP-based geolocation
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

  /// ✏️ Updates user's profile fields
  Future<void> updateUserInfo({
    required String username,
    required String uid,
    required String location,
  }) async {
    emit(LoadingUserInfoState());

    try {
      final updateRes = await supabase.from('users').update({
        'username': username,
        'profile_image': User!.profileImage,
        'location': location,
      }).eq('id', uid);

      // Only upload image if a new one was picked
      if (image != null) {
        await uploadPImage(
          image: image!,
          email: LocalData.getData(key: SharedKey.email),
          uid: uid,
        );
      }

      emit(UserInfoUpdatedSuccessfully());
      print('✅ User info updated: $updateRes');
    } catch (e) {
      emit(UserInfoUpdateError('Failed to update user info: $e'));
      print('❌ Error updating user info: $e');
    }
  }

  /// 🔍 Checks if profile fields or image were changed
  bool hasChanges() {
    final currentFullName = "${firstName.text.trim()} ${lastName.text.trim()}";
    final storedFullName = User?.userName.trim();
    final currentLocation = userLocation.text.trim();
    final storedLocation = User?.location.trim();

    final isImageChanged = image != null;

    return currentFullName != storedFullName ||
        currentLocation != storedLocation ||
        isImageChanged;
  }

  /// 🔍 Search for users by username (excluding self)
  Future<void> searchUser(String query) async {
  emit(SearchLoading());

  final myId = LocalData.getData(key: SharedKey.uid);

  try {
    // Search matching users
    final response = await supabase
        .from('users')
        .select()
        .ilike('username', '%$query%')
        .not('id', 'eq', myId);

    final users = (response as List)
        .map((e) => UserModel.fromJson(e))
        .toList();

    // Check friendship status with each user
    final friendRes = await supabase
        .from('friends')
        .select()
        .or('user_id.eq.$myId,friend_id.eq.$myId');

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

  /// 👥 Loads all users except current user
  Future<void> loadAllUsers() async {
    emit(UsersLoading());
    try {
      final myUid = LocalData.getData(key: SharedKey.uid);
      final res = await supabase.from('users').select('*').not('id', 'eq', myUid);

      final fetchedUsers = (res as List)
          .map((e) => UserModel.fromJson(e))
          .toList();

      emit(UsersLoaded(fetchedUsers));
    } catch (e) {
      emit(UsersLoadError('Failed to load users: $e'));
    }
  }
Future<void> addFriend(String friendId) async {
  final myId = LocalData.getData(key: SharedKey.uid);
  if (myId == null || myId == friendId) return;

  emit(FriendRequestLoading());

  try {
    final response = await supabase.from('friends').insert({
      'user_id': myId,
      'friend_id': friendId,
      'status': 'pending',
    }).select();

    print('✅ Friend request sent: $response');
    emit(FriendRequestSent(friendId));
  } on PostgrestException catch (e) {
    if (e.code == '23505') {
       print('❌ Duplicate friend request: ${e.message}');
      emit(FriendRequestError('You already sent a request or are already friends.'));
    } else {
      emit(FriendRequestError('Failed to send friend request: ${e.message}'));
    }
  } catch (e) {
    emit(FriendRequestError('Unexpected error: $e'));
  }
}








  /// ✅ Accept or revoke terms agreement
  @override
  void acceptTerms() {
    isAcceptTerms = !isAcceptTerms;
    emit(AcceptTermsState(isAcceptTerms));
  }

  /// 🧹 Dispose form controllers
  void disposeController() {
    userLocation.dispose();
    firstName.dispose();
    lastName.dispose();
  }
}
