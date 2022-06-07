import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../models/categories_model.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/size_config.dart';
import 'category_products_Screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        CategoriesModel categoriesModel =
            ShopAppCubit.get(context).categoriesModel!;

        return Scaffold(
          appBar: AppBar(
            leading: appBarLeading(context),
          ),
          body: ConditionalBuilder(
            condition: state is! ShopLoadingCategoryDataState &&
                ShopAppCubit.get(context).categoriesModel != null,
            builder: (context) => ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildCategoriesItemRow(
                    categoriesModel.data!.data[index],
                    context,
                    categoriesImage![index]),
                separatorBuilder: (context, index) => separated(),
                itemCount: categoriesModel.data!.data.length),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

List<String>? categoriesImage = [
  "assets/images/Image Banner 2.png",
  "assets/images/covid.jpg",
  "assets/images/sport.jpg",
  "assets/images/lightning.jpg",
  "assets/images/Image Banner 3.png",
];
Widget buildCategoriesItemRow(DataModel model, context, String image) =>
    InkWell(
      onTap: () {
        ShopAppCubit.get(context).getCategoriesDetailData(model.id);
        navigateTo(context, CategoryProductsDetailsScreen(model.name));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image),
                    ))),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.name!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
            )
          ],
        ),
      ),
    );
