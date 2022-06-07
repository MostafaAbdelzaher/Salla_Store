import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../models/categories_details.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/size_config.dart';
import '../product_details/product_details.dart';

class CategoryProductsDetailsScreen extends StatelessWidget {
  final String? name;
  const CategoryProductsDetailsScreen(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: SizedBox(
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
              title: Text(
                name!,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: ConditionalBuilder(
              condition:
                  ShopAppCubit.get(context).categoriesDetailModel != null &&
                      state is! ShopCategoryDetailsLoadingState,
              fallback: (BuildContext context) => const Center(
                child: Center(child: CircularProgressIndicator()),
              ),
              builder: (BuildContext context) => SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 35, top: 10),
                  color: Colors.grey.withOpacity(0.2),
                  child: GridView.count(
                    padding: const EdgeInsets.only(bottom: 2),
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1 / 1.45,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: List.generate(
                        ShopAppCubit.get(context)
                            .categoriesDetailModel!
                            .data
                            .productData
                            .length,
                        (index) => InkWell(
                            onTap: () {
                              navigateTo(
                                  context,
                                  ProductDetailsScreen(
                                    id: ShopAppCubit.get(context)
                                        .categoriesDetailModel!
                                        .data
                                        .productData[index]
                                        .id!,
                                  ));
                            },
                            child: buildGridItemCaCategory(
                                ShopAppCubit.get(context)
                                    .categoriesDetailModel!
                                    .data
                                    .productData[index],
                                context))),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget buildGridItemCaCategory(CategoryData model, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(alignment: AlignmentDirectional.bottomStart, children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Image(
                  image: NetworkImage(
                    model.image!,
                  ),
                  width: double.infinity,
                  height: 150,
                ),
              ),
              if (model.discount != 0)
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
            ]),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13.5, height: 1.2),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price!.round()}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice!.round()}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      const Spacer(),
                      Expanded(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            ShopAppCubit.get(context)
                                .changeFavorites(model.id!);
                          },
                          icon: CircleAvatar(
                              backgroundColor: kSecondaryColor.withOpacity(0.5),
                              radius: 15,
                              child: Icon(Icons.favorite,
                                  size: 20,
                                  color: ShopAppCubit.get(context)
                                          .favorites[model.id]!
                                      ? const Color(0xFFFF7643)
                                      : kSecondaryColor.withOpacity(0.5))),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
