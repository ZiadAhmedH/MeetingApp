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

// user Profile
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  static String countryName = '';
  // ignore: non_constant_identifier_names
  UserModel? User;

  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  static TextEditingController userLocation = TextEditingController();
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();
  static TextEditingController jobtitle = TextEditingController();

  final supabase = Supabase.instance.client;


  @override
  bool isAcceptTerms = false;

  static String currentStatus = 'Software Engineer';
  List<String> jobTitle = [
    'Software Engineer',
    'Doctor',
    'Nurse',
    'Teacher',
    'Student',
    'Businessman',
    'Others'
  ];

  Future<void> pickImageFromGallery(
      {required String uid, required String email}) async {
    emit(ImagePickerLoading());

    try {
      // Request multiple permissions for compatibility
      final photosPermission = await Permission.photos.request();
      final storagePermission = await Permission.storage.request();

      // Check if either permission is granted
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
        emit(
            ImagePickerError('Gallery permission is required to pick images.'));
      }
    } catch (e) {
      emit(ImagePickerError('Failed to pick image: $e'));
    }
  }

  Future<void> getUserInfo() async {
    emit(LoadingUserInfoState());

    try {

      final data = await supabase.from("users").select()
          .eq('id', LocalData.getData(key: SharedKey.uid))
          .single();

      User = UserModel.fromJson(data);
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
      return;
    }
      
  }


  Future<void> uploadPImage({
    required XFile image,
    required String email,
    required String uid,
  }) async {
    final imagePath = 'ProfileImage/$email/${image.path.split('/').last}';

    print("""

  📸 Uploading profile image:   
$imagePath
  User ID: $uid
  Email: $email 

""");

    try {
      final file = File(image.path);

      // Upload image
      await supabase.storage
          .from('avatars') // Replace with your bucket name
          .upload(imagePath, file,
              fileOptions: FileOptions(cacheControl: '3600', upsert: true));

      // Get public URL
      final publicUrl = supabase.storage
          .from('avatars') // Replace with your bucket name
          .getPublicUrl(imagePath);

      print('✅ Profile image uploaded successfully: $publicUrl');
      // Update user profile
      final updateRes = await supabase
          .from('users')
          .update({'profile_image': publicUrl}).eq('id', uid);

      print("🛠️ Update result: $updateRes");

      print('✅ Profile image uploaded and user updated.');
    } catch (e) {
      print('❌ Error uploading profile image: $e');
    }
  }

  // Changing Job Title
  void changingJobTitle(String value) {
    currentStatus = value;
    emit(ChangingStatusState());
  }

// Get Country
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

  
  Future<void> updateUserInfo(
      {required String username, required String uid , required String location}) async {
    emit(LoadingUserInfoState());
    try {
      final updateRes = await supabase
      .from('users')
      .update({
        'username': username,
        'profile_image': User!.profileImage,
        'location': location,
       }).eq('id', uid);
      
      
      await uploadPImage(
        image: image!,
        email: LocalData.getData(key: SharedKey.email),
        uid: uid,
      );


      emit(UserInfoUpdatedSuccessfully());
      print('User info updated successfully: $updateRes');
    } catch (e) {
      emit(UserInfoUpdateError('Failed to update user info: $e'));
      print('Error updating user info: $e');

      return;
      }
  }
  
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
