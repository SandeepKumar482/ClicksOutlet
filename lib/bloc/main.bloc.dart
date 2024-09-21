import 'package:apex_infinity/apex_infinity.dart';
import 'package:apex_infinity/http/response.dart';
import 'package:clicks_outlet/FirebaseService/auth.service.dart';
import 'package:clicks_outlet/config/api.config.dart';
import 'package:clicks_outlet/model/user_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MainCubitState {
  authenticated,
  guestUser
}

class MainCubit extends Cubit<MainCubitState> {

  UserDetailsModel?  userDetailsModel;

  MainCubit() : super(MainCubitState.guestUser) {
    userDetailsModel = UserDetailsModel.fromSP();
    if(userDetailsModel?.id != null) {
      emit(MainCubitState.authenticated);
    } else {
      emit(MainCubitState.guestUser);
    }
    getUserData();
  }

  bool isAuthenticated() {
    return state == MainCubitState.authenticated;
  }

  Future<void> getUserData() async {
    AxHttpResponse res = await Ax.httpRequest.get(url: APIConfig.useData);
    userDetailsModel = null;

    if(res.status) {
      userDetailsModel = UserDetailsModel.fromMap(map: res.data['user-data']);
      userDetailsModel?.setToSP();
    }
    if(userDetailsModel?.id != null) {
      emit(MainCubitState.authenticated);
    }

  }

  Future<void> logout() async {
    await GoogleAuthServices.signOut();

    await Ax.sharedPreference.clear();

    await Ax.httpRequest.get(url: APIConfig.logout,isFollowRedirect: true);

    emit(MainCubitState.guestUser);

  }



}