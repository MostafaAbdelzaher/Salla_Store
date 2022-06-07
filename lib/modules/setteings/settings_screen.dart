import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/modules/setteings/profile_screen.dart';
import 'package:salla_app/shard/component/constants.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../shard/component/component.dart';
import '../../../shard/network/local/cache_helper.dart';
import '../orders/order_screen.dart';
import '../login/shop_login.dart';
import 'faqs_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              itemSettingsBuilder(
                  text: "Profile",
                  icon: Icons.person,
                  onPress: () {
                    navigateTo(context, ProfileScreen());
                  }),
              itemSettingsBuilder(
                  text: "My orders",
                  icon: Icons.shopping_cart_sharp,
                  onPress: () {
                    navigateTo(context, const GetOrderScreen());
                  }),
              itemSettingsBuilder(
                text: "Language",
                icon: Icons.language,
              ),
              itemSettingsBuilder(
                onPress: () {
                  ShopAppCubit.get(context).changeThemMod();
                },
                icon2: Icon(
                  ShopAppCubit.get(context).changeIcon,
                  size: 40,
                  color: ShopAppCubit.get(context).isDark == false
                      ? kPrimaryColor
                      : null,
                ),
                //
                text: "Dark mode",
                icon: Icons.brightness_4,
              ),
              itemSettingsBuilder(
                  text: "FAQs",
                  icon: Icons.question_answer,
                  onPress: () {
                    navigateTo(context, FaQsScreen());
                  }),
              itemSettingsBuilder(
                  text: "LOGOUT",
                  icon: Icons.logout,
                  onPress: () {
                    CacheHelper.removeData('token').then((value) {
                      ShopAppCubit.get(context).currentIndex = 0;
                      if (value) {
                        navigateToAndFinish(
                          context,
                          const ShopLoginScreen(),
                        );
                      }
                    });
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget itemSettingsBuilder({
    required String text,
    required IconData icon,
    Icon icon2 = const Icon(Icons.arrow_forward_ios),
    Function? onPress,
  }) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            onPress!();
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 60,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(icon, size: 25, color: kPrimaryColor),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            text,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87),
                          ),
                          const Spacer(),
                          icon2
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
}
