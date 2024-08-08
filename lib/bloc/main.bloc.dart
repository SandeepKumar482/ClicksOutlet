import 'package:flutter_bloc/flutter_bloc.dart';

enum MainCubitState {
  authenticated,
  guestUser
}

class MainCubit extends Cubit<MainCubitState> {

  bool isLogin = false;

  MainCubit() : super(MainCubitState.guestUser) {
    emit(MainCubitState.authenticated);

  }

  bool isAuthenticated() {
    return state == MainCubitState.authenticated;
  }



}