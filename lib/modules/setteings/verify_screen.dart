import 'package:flutter/material.dart';
import 'package:salla_app/shard/component/component.dart';
import 'package:salla_app/shard/size_config.dart';

import '../../../shard/component/constants.dart';

class VerifyScreen extends StatelessWidget {
  final String email;

  const VerifyScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: appBarLeading(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              Text("We sent your code to $email"),
              buildItem(),
              SizedBox(
                height: SizeConfig.screenHeight * 0.15,
              ),
              const OTPForm(),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              SizedBox(
                height: 60,
                child: defaultButton(
                  text: "Continue",
                  color: kPrimaryColor,
                  width: SizeConfig.screenWidth * 0.9,
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              GestureDetector(
                onTap: () {
                  navigateTo(
                      context,
                      VerifyScreen(
                        email: email,
                      ));
                },
                child: const Text(
                  "Resend OTOP code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Row buildItem() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("This code will expired in"),
      TweenAnimationBuilder(
        tween: Tween(begin: 30.0, end: 0),
        duration: const Duration(seconds: 30),
        builder: (context, dynamic value, child) => Text(
          " 00:${value.toInt()}",
          style: const TextStyle(color: kPrimaryColor),
        ),
        onEnd: () {},
      )
    ],
  );
}

class OTPForm extends StatefulWidget {
  const OTPForm({Key? key}) : super(key: key);

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: getProportionateScreenWidth(60),
            child: TextFormField(
              obscureText: true,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: otpInputDecoration,
              onChanged: (value) {
                nextField(value, pin2FocusNode);
              },
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(60),
            child: TextFormField(
              obscureText: true,
              focusNode: pin2FocusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: otpInputDecoration,
              onChanged: (value) {
                nextField(value, pin3FocusNode);
              },
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(60),
            child: TextFormField(
              focusNode: pin3FocusNode,
              obscureText: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: otpInputDecoration,
              onChanged: (value) {
                nextField(value, pin4FocusNode);
              },
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(60),
            child: TextFormField(
                obscureText: true,
                focusNode: pin4FocusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpInputDecoration,
                onChanged: (value) {
                  if (value.length == 1) {
                    pin4FocusNode!.unfocus();
                  }
                }),
          ),
        ],
      )),
    );
  }
}

final otpInputDecoration = InputDecoration(
    contentPadding:
        EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
    enabledBorder: outlinedBorder(),
    focusedBorder: outlinedBorder(),
    border: outlinedBorder());

OutlineInputBorder outlinedBorder() => OutlineInputBorder(
    borderSide: const BorderSide(color: kTextColor),
    borderRadius: BorderRadius.circular(15));
