import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/modules/setteings/verify_screen.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';

class ProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopAppCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return Scaffold(
          appBar: AppBar(
            leading: appBarLeading(context),
          ),
          body: ConditionalBuilder(
            condition: ShopAppCubit.get(context).userModel != null &&
                state is! ShopLoadingGetUserDataState,
            fallback: (context) => const CircularProgressIndicator(),
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Center(
                  child: Column(
                    children: [
                      if (state is ShopLoadingUpdateDataState)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: LinearProgressIndicator(),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        type: TextInputType.text,
                        controller: nameController,
                        hint: "Enter your name",
                        prefix: Icons.person,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        type: TextInputType.text,
                        controller: emailController,
                        hint: "Enter email address",
                        prefix: Icons.email,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        type: TextInputType.number,
                        controller: phoneController,
                        hint: "Enter your phone",
                        prefix: Icons.phone,
                      ),
                      const SizedBox(height: 25),
                      defaultButton(
                          text: "UPDATE",
                          width: 350,
                          function: () {
                            ShopAppCubit.get(context).updateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text);
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "verify account",
                            style: TextStyle(fontSize: 13),
                          ),
                          TextButton(
                              onPressed: () {
                                navigateTo(context,
                                    VerifyScreen(email: emailController.text));
                              },
                              child: const Text("verify ")),
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
    );
  }
}
