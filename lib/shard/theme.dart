import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'component/constants.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: kPrimaryColor,
    primarySwatch: kPrimaryColor,
    focusColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light),
    iconTheme: IconThemeData(color: Colors.black),
  );
}
