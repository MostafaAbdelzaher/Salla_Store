import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/network/local/cache_helper.dart';
import '../../../shard/size_config.dart';
import '../login/shop_login.dart';

class OnBoardingScreen extends StatelessWidget {
  var boardController = PageController();
  List<Map<String, String>> onBoarding = [
    {
      "text": "Explore",
      "body":
          "Choose What ever the Product you wish for with the easiest way possible using Salla",
      "image": "assets/images/splash_1.png"
    },
    {
      "text": "Make the Payment",
      "body": "Pay with the safest way possible either by cash or credit cards",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "Shipping",
      "body":
          "Yor Order will be shipped to you as fast as possible by our carrier",
      "image": "assets/images/splash_3.png"
    },
  ];
  bool? isLast = false;

  OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    bool? isLast = false;

    void getLoginScreen() {
      CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
        if (value) {
          navigateToAndFinish(context, const ShopLoginScreen());
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: getLoginScreen,
              child: const Text(
                "Skip",
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 440,
                child: PageView.builder(
                  controller: boardController,
                  onPageChanged: (value) {
                    if (value == onBoarding.length - 1) {
                      isLast = true;
                    } else {
                      print(isLast);
                    }
                  },
                  itemCount: onBoarding.length,
                  itemBuilder: (context, index) => OnBoardingBuilder(
                    model: onBoarding[index],
                  ),
                ),
              ),
              SmoothPageIndicator(
                controller: boardController,
                count: onBoarding.length,
                effect: const ExpandingDotsEffect(
                  dotColor: Colors.grey,
                  activeDotColor: kPrimaryColor,
                  dotHeight: 10,
                  expansionFactor: 4,
                  dotWidth: 13,
                  spacing: 5,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50, right: 20, left: 20),
                child: defaultButton(
                    color: kPrimaryColor,
                    text: "continue",
                    function: () {
                      if (isLast!) {
                        getLoginScreen();
                      } else {
                        boardController.nextPage(
                          duration: const Duration(
                            seconds: 1,
                          ),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}

class OnBoardingBuilder extends StatelessWidget {
  Map model;

  OnBoardingBuilder({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          model["text"],
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(30)),
          child: Text(
            model["body"],
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Image.asset(
          model['image'],
          height: getProportionateScreenHeight(200),
          width: getProportionateScreenWidth(200),
        ),
      ],
    );
  }
}
