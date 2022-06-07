import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/layout/cubit/cubit.dart';
import 'package:salla_app/shard/size_config.dart';
import '../../../layout/shop_layout.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/network/local/cache_helper.dart';
import '../register_screen/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLoginScreen extends StatefulWidget {
  const ShopLoginScreen({Key? key}) : super(key: key);

  @override
  State<ShopLoginScreen> createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveData(
                      key: "token", value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token!;
                navigateToAndFinish(
                  context,
                  const ShopLayoutScreen(),
                );
                ShopAppCubit.get(context).getHomeData();
              });
              showToast(
                  text: state.loginModel.message!, state: ToastStates.SUCCESS);
            } else {
              showToast(
                  text: state.loginModel.message!, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          SizeConfig().init(context);
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
                          "LOGIN",
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login now to browse our hot offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTextFormField(
                          hint: "Enter your Email Address",
                          prefix: Icons.email,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter your  email";
                            }
                            return null;
                          },
                          type: TextInputType.emailAddress,
                          controller: emailController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                            hint: "Enter your Password",
                            prefix: Icons.lock,
                            showPassword:
                                ShopLoginCubit.get(context).isPassword,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            type: TextInputType.text,
                            controller: passwordController,
                            suffixPress: () {
                              ShopLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            suffix: ShopLoginCubit.get(context).suffix),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              text: "LOGIN",
                              width: 400,
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              }),
                          fallback: (context) =>
                              const CircularProgressIndicator(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "don't have an account?",
                              style: TextStyle(fontSize: 13),
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                child: const Text("Register now")),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialCard(
                              icon: "assets/icons/google-icon.svg",
                              press: () {
                                navigateTo(context, RegisterScreen());
                              },
                            ),
                            SocialCard(
                              icon: "assets/icons/facebook-2.svg",
                              press: () {
                                navigateTo(context, RegisterScreen());
                              },
                            ),
                            SocialCard(
                              icon: "assets/icons/twitter.svg",
                              press: () {
                                navigateTo(context, RegisterScreen());
                              },
                            ),
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
      ),
    );
  }
}
