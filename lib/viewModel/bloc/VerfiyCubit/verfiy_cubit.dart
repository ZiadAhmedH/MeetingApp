import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'verfiy_state.dart';

class VerfiyCubit extends Cubit<VerfiyState> {
  VerfiyCubit() : super(VerfiyInitial());
}
