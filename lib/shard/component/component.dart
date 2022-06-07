import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../size_config.dart';
import 'constants.dart';

Widget defaultButton({
  Color color = kPrimaryColor,
  double width = double.infinity,
  Function? function,
  double height = 55,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () => function!(),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(28),
  borderSide: const BorderSide(color: kTextColor),
  gapPadding: 10,
);
Widget defaultTextFormField({
  bool showPassword = false,
  required TextInputType type,
  required TextEditingController controller,
  onFieldSubmitted,
  onChanged,
  onTap,
  Function? validator,
  IconData? prefix,
  IconData? suffix,
  suffixPress,
  String? hint,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 60,
      child: TextFormField(
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        obscureText: showPassword,
        keyboardType: type,
        controller: controller,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        validator: (value) => validator!(value),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          errorStyle: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.normal,
            height: 2,
          ),
          hintText: hint,
          hintStyle:
              const TextStyle(height: 2.5, fontSize: 15, color: Colors.grey),
          prefixIcon: Icon(
            prefix,
          ),
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 15, minWidth: 50),
          suffix: IconButton(
            onPressed: suffixPress,
            icon: Icon(
              suffix,
            ),
          ),
        ),
      ),
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
void navigateToAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => widget), (route) {
      return false;
    });
void showToast({required String text, required ToastStates state}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key,
    this.icon,
    this.press,
  }) : super(key: key);

  final String? icon;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press as void Function()?,
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        padding: EdgeInsets.all(getProportionateScreenWidth(12)),
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(40),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon!),
      ),
    );
  }
}

Widget separated() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 0.6,
        width: double.infinity,
        color: Colors.blueGrey,
      ),
    );
SizedBox appBarLeading(BuildContext context, {num height = 18}) {
  return SizedBox(
    height: getProportionateScreenWidth(40),
    width: getProportionateScreenWidth(40),
    child: TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: () => Navigator.pop(context),
      child: SvgPicture.asset("assets/icons/Back ICon.svg",
          height: height.toDouble(), color: kSecondaryColor),
    ),
  );
}
