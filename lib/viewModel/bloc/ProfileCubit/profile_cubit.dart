import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);


  XFile? image;
  final ImagePicker _picker = ImagePicker();


  Future<void> pickImageFromGallery() async {
    emit(ImagePickerLoading());

    var permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      try {
        XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          image = pickedFile;
          print(image!.path);
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
      emit(ImagePickerError('Permission permanently denied. Please enable it in settings.'));
    }
  }





}
