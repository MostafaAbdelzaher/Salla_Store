import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salla_app/modules/In_cart_screen/In_cart_screen.dart';
import 'package:salla_app/shard/component/constants.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../models/categories_model.dart';
import '../../../models/home_model.dart';
import '../../../shard/component/component.dart';
import '../../../shard/size_config.dart';
import '../categories/categories_screen.dart';
import '../categories/category_products_Screen.dart';
import '../notifications_screen/notifications_screen.dart';
import '../product_details/product_details.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesDataState) {
          if (state.changeFavoritesModel!.status!) {
            showToast(
                text: state.changeFavoritesModel!.message!,
                state: ToastStates.SUCCESS);
          }
        }
      },
      builder: (context, state) {
        SizeConfig().init(context);
        ShopAppCubit cubit = ShopAppCubit.get(context);

        List<Map<String, dynamic>> categories = [
          {"icon": "assets/icons/Flash Icon.svg", "text": "Flash\nDeal"},
          {"icon": "assets/icons/Bill Icon.svg", "text": "Bill"},
          {"icon": "assets/icons/Game Icon.svg", "text": "Game"},
          {"icon": "assets/icons/Gift Icon.svg", "text": "Daily\nGift"},
          {"icon": "assets/icons/Discover.svg", "text": "More"},
        ];
        List<String>? categoriesImage = [
          "assets/images/Image Banner 2.png",
          "assets/images/covid.jpg",
          "assets/images/sport.jpg",
          "assets/images/lightning.jpg",
          "assets/images/Image Banner 3.png",
        ];
        return SafeArea(
            top: false,
            child: ConditionalBuilder(
                builder: (BuildContext context) => homeBuilder(
                    context,
                    categories,
                    cubit,
                    categoriesImage,
                    cubit.homeModel!.data!.products),
                fallback: (BuildContext context) =>
                    const Center(child: CircularProgressIndicator()),
                condition: cubit.homeModel != null &&
                    cubit.categoriesModel != null &&
                    cubit.inCartGetModel != null &&
                    cubit.notifications != null));
      },
    );
  }

  Padding homeBuilder(
      BuildContext context,
      List<Map<String, dynamic>> categories,
      ShopAppCubit cubit,
      List<String> categoriesImage,
      List<ProductsModel> homeList) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: getProportionateScreenWidth(20),
            ),
            homeHeader(context),
            SizedBox(
              height: getProportionateScreenWidth(30),
            ),
            banner(),
            SizedBox(
              height: getProportionateScreenWidth(30),
            ),
            Categories(categories: categories),
            SizedBox(
              height: getProportionateScreenWidth(30),
            ),
            specialOffers(context, cubit, categoriesImage), //
            SizedBox(
              height: getProportionateScreenWidth(25),
            ),
            sectionTitle(context, "Popular product"), // section title
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Container(
                color: Colors.grey[100]!.withOpacity(0.5),
                height: 238,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      productCard(homeList[index], context),
                  scrollDirection: Axis.horizontal,
                  itemCount: homeList.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productCard(ProductsModel homeList, BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            ProductDetailsScreen(
              id: homeList.id,
            ));
      },
      child: Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(8)),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          width: getProportionateScreenWidth(140),
          height: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                homeList.image!,
                              )),
                        ),
                      ),
                    ),
                    if (homeList.discount != 0)
                      Container(
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'discount',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  homeList.name.toString(),
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${homeList.price}',
                      style: const TextStyle(
                          color: Color(0xFFFF7643),
                          fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        ShopAppCubit.get(context).changeFavorites(homeList.id);
                      },
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(6)),
                        height: getProportionateScreenWidth(28),
                        width: getProportionateScreenWidth(28),
                        decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          "assets/icons/Heart Icon_2.svg",
                          color:
                              ShopAppCubit.get(context).favorites[homeList.id]!
                                  ? const Color(0xFFFF7643)
                                  : kSecondaryColor.withOpacity(0.5),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Column specialOffers(
    BuildContext context, ShopAppCubit cubit, List<String> categoriesImage) {
  return Column(
    children: [
      sectionTitle(context, "Special for you"), //
      SizedBox(
        height: getProportionateScreenWidth(25),
      ),
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cubit.categoriesModel!.data!.data.length,
          itemBuilder: (context, index) => SpecialOferCard(
            model: cubit.categoriesModel!.data!.data[index],
            image: categoriesImage[index],
          ),
        ),
      ),
    ],
  );
}

Padding sectionTitle(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: getProportionateScreenWidth(18), color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesScreen()));
          },
          child: const Text("see more "),
        ),
      ],
    ),
  );
}

Padding banner() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(15)),
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0xFF4A3298),
          borderRadius: BorderRadius.circular(20)),
      child: const Text.rich(TextSpan(
          text: "A Summer Surprise\n",
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
                text: "Cashbak 20%",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ])),
    ),
  );
}

Padding homeHeader(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.6,
          decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15)),
          child: TextField(
            onTap: () {
              navigateTo(context, SearchScreen());
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                    vertical: getProportionateScreenWidth(9)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search product",
                prefixIcon: const Icon(Icons.search)),
          ),
        ),
        buildIconButton(
          press: () {
            navigateTo(
                context,
                const InCartScreen(
                  fromNotification: true,
                ));
          },
          numOfItem:
              ShopAppCubit.get(context).inCartGetModel!.data!.cartItems.length,
          context: context,
          svg: "assets/icons/Cart Icon.svg",
        ),
        buildIconButton(
          press: () {
            ShopAppCubit.get(context).getNotifications();
            navigateTo(context, const NotificationsScreen());
          },
          numOfItem: ShopAppCubit.get(context).notifications!.data!.total,
          context: context,
          svg: "assets/icons/Bell.svg",
        ),
      ],
    ),
  );
}

InkWell buildIconButton(
    {required BuildContext context,
    required String svg,
    int? numOfItem,
    required Function press}) {
  return InkWell(
    borderRadius: BorderRadius.circular(50),
    onTap: () {
      press();
    },
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.all(getProportionateScreenWidth(12)),
          decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1), shape: BoxShape.circle),
          child: SvgPicture.asset(svg),
        ),
        if (numOfItem != 0)
          Positioned(
              top: -1,
              right: 0,
              child: Container(
                height: getProportionateScreenWidth(16),
                width: getProportionateScreenWidth(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "${numOfItem!}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ))
      ],
    ),
  );
}

class SpecialOferCard extends StatelessWidget {
  const SpecialOferCard({
    Key? key,
    required this.model,
    required this.image,
  }) : super(key: key);
  final DataModel model;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: () {
          ShopAppCubit.get(context).getCategoriesDetailData(model.id);
          navigateTo(context, CategoryProductsDetailsScreen(model.name));
        },
        child: SizedBox(
          height: getProportionateScreenWidth(100),
          width: getProportionateScreenWidth(242),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.4),
                        const Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                        vertical: getProportionateScreenWidth(10)),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "${model.name}\n",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({Key? key, required this.categories}) : super(key: key);
  final List<Map<String, dynamic>> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            categories.length,
            (index) => categoryCard(
              icon: categories[index]["icon"],
              text: categories[index]["text"],
            ),
          )
        ],
      ),
    );
  }

  SizedBox categoryCard(
      {required String icon, required String text, GestureTapCallback? press}) {
    return SizedBox(
      width: getProportionateScreenWidth(55),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(
                getProportionateScreenWidth(15),
              ),
              decoration: BoxDecoration(
                  color: const Color(0XFFFFECDF),
                  borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset(icon),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
