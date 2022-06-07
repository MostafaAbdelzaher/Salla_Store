import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../models/detail_model.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/size_config.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int id;
  const ProductDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var pageControlLar = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopAppCubit>(context)
        ..getDetailsProduct(widget.id.toString()),
      child:
          BlocConsumer<ShopAppCubit, ShopAppStates>(listener: (context, stata) {
        if (stata is ShopSuccessInCartDataState) {
          if (stata.inCartChange.status!) {
            showToast(
                text: stata.inCartChange.message!, state: ToastStates.SUCCESS);
          } else {
            showToast(
                text: stata.inCartChange.message!, state: ToastStates.ERROR);
          }
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child: const CustomAppBar(
              rating: 5.5,
            ),
          ),
          body: state is! ShopLoadingGetProductDetailsDataStats &&
                  ShopAppCubit.get(context).productDetailsModel != null
              ? buiDetails(
                  context, ShopAppCubit.get(context).productDetailsModel)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }

  Widget buiDetails(
    context,
    ProductDetailsModel? model,
  ) {
    List<Widget> images = [];

    for (var element in model!.data!.images) {
      images.add(Image.network(
        element,
        width: 230,
        fit: BoxFit.contain,
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 15,
          ),
          CarouselSlider(
              items: images,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  ShopAppCubit.get(context).changeIndex(index);
                },
                height: 230,
              )),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: AnimatedSmoothIndicator(
                effect: ExpandingDotsEffect(
                    dotHeight: 7,
                    dotWidth: 15,
                    spacing: 1,
                    activeDotColor: kPrimaryColor,
                    dotColor: kPrimaryColor.withOpacity(0.12)),
                activeIndex: ShopAppCubit.get(context).currentIndex,
                count: images.length),
          ),
          const SizedBox(
            height: 10,
          ),
          productDescription(
            model,
            context,
          )
        ],
      ),
    );
  }

  Column productDescription(ProductDetailsModel model, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
          child: Text(
            model.data!.name!,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            if (model.data!.discount != 0)
              Container(
                margin: const EdgeInsets.only(left: 20),
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'discount',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  ShopAppCubit.get(context).changeFavorites(model.data!.id!);
                },
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                  width: getProportionateScreenWidth(64),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: ShopAppCubit.get(context).favorites[model.data!.id]!
                        ? const Color(0xFFFFE6E6)
                        : const Color(0xFFF5F6F9),
                  ),
                  child: SvgPicture.asset("assets/icons/Heart Icon_2.svg",
                      height: 20,
                      color:
                          ShopAppCubit.get(context).favorites[model.data!.id]!
                              ? const Color(0xFFFF4848)
                              : const Color(0xFFDBDEE4)),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(30)),
          child: Text(
            model.data!.description!,
            maxLines: !ShopAppCubit.get(context).seeMore ? 10 : 50,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: GestureDetector(
            onTap: () {
              ShopAppCubit.get(context).changeSeeMore();
            },
            child: Text(
              !ShopAppCubit.get(context).seeMore
                  ? "See more .. "
                  : "See less ..",
              style: const TextStyle(
                  color: kPrimaryColor, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
          padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF6F7F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "\$${model.data!.price.toInt().toString()}",
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    if (model.data!.oldPrice != model.data!.price)
                      Text(
                        model.data!.oldPrice.toString(),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 30.0),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: defaultButton(
                      text: "Add to Chart",
                      width: 250,
                      function: () {
                        ShopAppCubit.get(context).inCarts(model.data!.id!);
                      }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

Widget roundedCounter({required String icon, required Function press}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20.0),
    child: InkWell(
      onTap: press(),
      child: Container(
        padding: const EdgeInsets.all(11),
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          icon,
        ),
      ),
    ),
  );
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, required this.rating}) : super(key: key);
  final double rating;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: getProportionateScreenWidth(40),
              width: getProportionateScreenWidth(40),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  primary: kPrimaryColor,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/Back ICon.svg",
                  height: 15,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.withOpacity(0.15)),
              child: Row(
                children: [
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset("assets/icons/Star Icon.svg")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
