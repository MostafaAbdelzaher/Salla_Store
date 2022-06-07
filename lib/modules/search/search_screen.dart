import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/size_config.dart';
import '../favorites/favorite_screen.dart';
import '../product_details/product_details.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    appBarLeading(context, height: 18),
                    const SizedBox(
                      width: 35,
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        onSubmitted: (String value) {
                          ShopAppCubit.get(context).getSearchData(value);
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
                  ],
                ),
              ),
              if (state is ShopLoadingSearchDataStatus)
                const SizedBox(
                  height: 100,
                ),
              if (state is ShopLoadingSearchDataStatus)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (state is ShopSuccessSearchDataStatus)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                navigateTo(
                                  context,
                                  ProductDetailsScreen(
                                    id: ShopAppCubit.get(context)
                                        .searchModel!
                                        .data!
                                        .data![index]
                                        .id!,
                                  ),
                                );
                              },
                              child: buildListProduct(
                                  ShopAppCubit.get(context)
                                      .searchModel!
                                      .data!
                                      .data![index],
                                  context),
                            ),
                        separatorBuilder: (context, index) => separated(),
                        itemCount: ShopAppCubit.get(context)
                            .searchModel!
                            .data!
                            .data!
                            .length),
                  ),
                ),
            ]),
          ),
        );
      },
    );
  }
}
