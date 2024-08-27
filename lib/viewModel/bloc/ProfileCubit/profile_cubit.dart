import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../model/Models/UserModel.dart';
import '../../../utils/CollectionConst.dart';
import '../../data/SharedKeys.dart';
import '../../data/SharedPrefrences.dart';
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


// Image Picker
  Future<void> pickImageFromGallery() async {
    emit(ImagePickerLoading());
    var permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      try {
        XFile? pickedFile = await _picker.pickImage(
            source: ImageSource.gallery);
        if (pickedFile != null) {
          image = pickedFile;
          emit(ImagePickerSuccess(pickedFile));
        } else {
          emit(ImagePickerError('No image selected.'));
        }
      } catch (e) {
        emit(ImagePickerError('Failed to pick image: $e'));
      }
    } else if (permissionStatus.isDenied) {
      emit(ImagePickerError('Gallery permission is required to pick images'));
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
      emit(ImagePickerError(
          'Permission permanently denied. Please enable it in settings.'));
    }
  }
  Future<void>getUserInfoFire()async {
    emit(LoadingUserInfoState());
    await FirebaseFirestore.instance.collection(Collections.users).snapshots().listen((value) {
      for (var doc in value.docs) {
        String docUid = doc.get('uid');
        if (LocalData.getData(key: SharedKey.uid) == docUid) {
          print(doc.id);
          print(LocalData.getData(key: SharedKey.uid));
          User = UserModel(
            email: doc.get('Email'),
            userName: doc.get("UserName"),
            profileImage: doc.get("profileImage"),
            phone: doc.get("phone"),
            location: doc.get("Location"),
            jobTitle: doc.get("JobTitle"),
          );
          print(User?.email);
        }
      }
      emit(SuccessUserInfoState());
    });
  }

  void uploadImage(
      {required XFile image , required String email,required uid})  async {
    print(image.name);
    print("The UUUUUUSSSSSEEERRRR Email IS $email");
    FirebaseStorage.instance.ref()
        .child("ProfileImage/$email/${image.name}")
        .putFile(File(image.path)).then((value){
      value.ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance.collection(Collections.users).doc(uid).update({
          "profileImage": value
        });
      });
    });


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


}
