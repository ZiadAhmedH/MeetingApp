import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../model/Models/UserModel.dart';

import '../CommonFunction.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState>  implements CommonFun {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);
  final Dio dio = Dio();

// user Profile
   XFile? image;
  final ImagePicker _picker = ImagePicker();
  static String countryName = '';
  UserModel? User;

  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  static TextEditingController userLocation = TextEditingController();
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();

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


Future<void> pickImageFromGallery({required String uid, required String email}) async {
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


  Future<void>getUserInfoFire()async {
    emit(LoadingUserInfoState());
    // await FirebaseFirestore.instance.collection(Collections.users).snapshots().listen((value) {
    //   for (var doc in value.docs) {
    //     String docUid = doc.get('uid');
    //     if (LocalData.getData(key: SharedKey.uid) == docUid) {
    //       print(doc.id);
    //       print(LocalData.getData(key: SharedKey.uid));
    //       User = UserModel(
    //         email: doc.get('Email'),
    //         userName: doc.get("UserName"),
    //         profileImage: doc.get("profileImage"),
    //         phone: doc.get("phone"),
    //         location: doc.get("Location"),
    //         jobTitle: doc.get("JobTitle"),
    //       );
    //       print(User?.email);
    //     }
    //   }
    //   emit(SuccessUserInfoState());
    // });
  }


final supabase = Supabase.instance.client;

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
        .upload(imagePath, file, fileOptions: FileOptions(cacheControl: '3600', upsert: true));

    // Get public URL
    final publicUrl =  supabase.storage
        .from('avatars') // Replace with your bucket name
        .getPublicUrl(imagePath);

    print('✅ Profile image uploaded successfully: $publicUrl');
    // Update user profile
     final updateRes = await supabase
    .from('users')
    .update({'profile_image': publicUrl})
    .eq('id', uid);

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


  @override
  void acceptTerms() {
    isAcceptTerms = !isAcceptTerms;
    emit(AcceptTermsState(isAcceptTerms));
  }


  void disposeController(){
    userLocation.dispose();
    firstName.dispose();
    lastName.dispose();
  }


}
