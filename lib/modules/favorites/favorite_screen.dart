import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../product_details/product_details.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesDataState) {
          if (state.changeFavoritesModel!.status!) {
            showToast(
                text: state.changeFavoritesModel!.message!,
                state: ToastStates.SUCCESS);
          } else {
            showToast(
                text: state.changeFavoritesModel!.message!,
                state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Expanded(
                  child: ConditionalBuilder(
                      condition: state is! ShopLoadingGetFavoritesDataState &&
                          ShopAppCubit.get(context).favoritesModel != null,
                      builder: (context) => ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildInkWell(context, index),
                          separatorBuilder: (context, index) => separated(),
                          itemCount: ShopAppCubit.get(context)
                              .favoritesModel!
                              .data!
                              .data!
                              .length),
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator())),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InkWell buildInkWell(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            ProductDetailsScreen(
                id: ShopAppCubit.get(context)
                    .favoritesModel!
                    .data!
                    .data![index]
                    .product!
                    .id!));
      },
      child: buildListProduct(
          ShopAppCubit.get(context).favoritesModel!.data!.data![index].product!,
          context),
    );
  }
}

Widget buildListProduct(model, context) => Padding(
    padding: const EdgeInsets.all(20),
    child: SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(alignment: Alignment.bottomLeft, children: [
            Image(
              image: NetworkImage(model.image!),
              width: 120,
              height: 120,
            ),
            if (model.discount != 0)
              Container(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "DISCOUNT",
                    style: TextStyle(fontSize: 8.5, color: Colors.white),
                  ),
                ),
                color: Colors.red,
              ),
          ]),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13.5, height: 1.2),
                ),
                const Spacer(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${model.price!.round()}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice!.round()}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ShopAppCubit.get(context).changeFavorites(model.id!);
                        },
                        icon: CircleAvatar(
                            backgroundColor: kSecondaryColor.withOpacity(0.2),
                            radius: 20,
                            child: Icon(Icons.favorite,
                                size: 25,
                                color: ShopAppCubit.get(context)
                                        .favorites[model.id]!
                                    ? const Color(0xFFFF7643)
                                    : kSecondaryColor.withOpacity(0.2))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ));
