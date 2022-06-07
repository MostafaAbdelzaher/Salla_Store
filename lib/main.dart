import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/shard/bloc_observer.dart';
import 'package:salla_app/shard/component/constants.dart';
import 'package:salla_app/shard/network/local/cache_helper.dart';
import 'package:salla_app/shard/network/remote/dio_helper.dart';
import 'package:salla_app/shard/theme.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'layout/shop_layout.dart';
import 'modules/login/shop_login.dart';
import 'modules/on_boarding/on_boarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () async {
      DioHelper.init();
      await CacheHelper.init();
      dynamic onBoarding = CacheHelper.getData(key: 'onBoarding');
      token = CacheHelper.getData(key: 'token');
      print(token);
      Widget widget;
      if (onBoarding != null) {
        if (token != null) {
          widget = const ShopLayoutScreen();
        } else {
          widget = const ShopLoginScreen();
        }
      } else {
        widget = OnBoardingScreen();
      }
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  const MyApp({
    Key? key,
    this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopAppCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavoritesData()
              ..getInCartData()
              ..getUserData()
              ..getAddresses()
              ..getOrders()
              ..getFaqs()
              ..getNotifications()),
      ],
      child: BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: theme(),
            home: startWidget,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
