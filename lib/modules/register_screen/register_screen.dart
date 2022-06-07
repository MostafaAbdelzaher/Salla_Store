import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/layout/cubit/cubit.dart';
import 'package:salla_app/modules/login/shop_login.dart';
import '../../../layout/shop_layout.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return BlocProvider(
        create: (context) => ShopRegisterCubit(),
        child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
          listener: (context, state) {
            if (state is ShopRegisterSuccessState) {
              if (state.registerModel.status!) {
                CacheHelper.saveData(
                        key: "token", value: state.registerModel.data!.token)
                    .then((value) {
                  token = state.registerModel.data!.token!;
                  ShopAppCubit.get(context).getUserData();
                  navigateToAndFinish(context, const ShopLayoutScreen());
                });
                showToast(
                    text: state.registerModel.message!,
                    state: ToastStates.SUCCESS);
              } else {
                showToast(
                    text: state.registerModel.message!,
                    state: ToastStates.ERROR);
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text(
                            "REGISTER",
                            style: TextStyle(fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Register now to browse our hot offers",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          defaultTextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter your name";
                                }
                              },
                              type: TextInputType.name,
                              controller: nameController,
                              prefix: Icons.person,
                              hint: "Enter your name"),
                          const SizedBox(
                            height: 25,
                          ),
                          defaultTextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter your Email Address";
                                } else if (!emailValidatorRegExp
                                    .hasMatch(value)) {
                                  return "Please Enter Valid Email";
                                }
                              },
                              type: TextInputType.emailAddress,
                              controller: emailController,
                              prefix: Icons.email,
                              hint: "Enter your Email Address"),
                          const SizedBox(
                            height: 25,
                          ),
                          defaultTextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Enter your password";
                              } else if (value.length < 8) {
                                return "Password is too short";
                              }
                            },
                            type: TextInputType.visiblePassword,
                            controller: passwordController,
                            prefix: Icons.lock,
                            hint: "Enter your password",
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          defaultTextFormField(
                              onFieldSubmitted: (value) {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter your phone";
                                }
                              },
                              type: TextInputType.phone,
                              controller: phoneController,
                              prefix: Icons.phone,
                              hint: "Enter your phone"),
                          const SizedBox(
                            height: 40,
                          ),
                          ConditionalBuilder(
                            condition: state is! ShopRegisterLoadingState,
                            builder: (context) => defaultButton(
                                text: "REGISTER",
                                color: kPrimaryColor,
                                width: widthScreen * 0.9,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                }),
                            fallback: (context) =>
                                const CircularProgressIndicator(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "I have an account",
                                style: TextStyle(fontSize: 13),
                              ),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(
                                        context, const ShopLoginScreen());
                                  },
                                  child: const Text("Login ")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
