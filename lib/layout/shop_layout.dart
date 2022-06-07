import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/shard/component/constants.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLayoutScreen extends StatelessWidget {
  const ShopLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);

        return Scaffold(
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: SalomonBottomBar(
            selectedItemColor: kPrimaryColor,
            duration: const Duration(
              seconds: 2,
            ),
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: cubit.navList,
          ),
        );
      },
    );
  }
}
