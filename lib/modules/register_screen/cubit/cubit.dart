import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/modules/register_screen/cubit/states.dart';

import '../../../../models/login_model.dart';
import '../../../../shard/network/remote/dio_helper.dart';
import '../../../../shard/network/remote/end_points.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());
  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  LoginModel? registerModel;
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());

    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    ).then((value) {
      registerModel = LoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(registerModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopRegisterErrorState(error: error.toString()));
    });
  }

  void verifyEmail({
    required String email,
  }) {
    emit(ShopRegisterLoadingState());

    DioHelper.postData(
      url: "verify-email",
      data: {
        'email': email,
      },
    ).then((value) {
      emit(ShopVerifySuccessState(message: value.data["message"]));
    }).catchError((error) {
      print(error.toString());
      emit(ShopVerifyErrorState());
    });
  }
}
