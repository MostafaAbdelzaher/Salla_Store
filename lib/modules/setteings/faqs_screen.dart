import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/shard/component/component.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../models/faqs_model.dart';
import '../../../shard/network/local/cache_helper.dart';
import '../orders/order_screen.dart';
import '../login/shop_login.dart';

class FaQsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FAQsModel model = ShopAppCubit.get(context).faQsModel!;
        return Scaffold(
          appBar: AppBar(
            leading: appBarLeading(context),
            title: const Text(
              "FAQS",
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.question_answer),
              )
            ],
          ),
          body: ListView.separated(
              itemBuilder: (context, index) => faqsItem(context, model, index),
              separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      child: Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                  ),
              itemCount: model.data!.data!.length),
        );
      },
    );
  }

  Widget faqsItem(context, FAQsModel model, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${model.data!.data![index].question} ",
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${model.data!.data![index].answer}",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
