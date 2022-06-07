import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/modules/login/cubit/states.dart';

import '../../../../models/login_model.dart';
import '../../../../shard/network/remote/dio_helper.dart';
import '../../../../shard/network/remote/end_points.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());
  static ShopLoginCubit get(context) => BlocProvider.of(context);
  LoginModel? loginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      emit(ShopLoginErrorState(error: error.toString()));
    });
  }

  IconData? suffix;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility;
    emit(ChangePasswordVisibility());
  }
}
