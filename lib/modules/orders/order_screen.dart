import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../layout/cubit/cubit.dart';
import '../../../../../layout/cubit/states.dart';
import '../../../../../shard/component/constants.dart';
import '../../../models/orders_model.dart';

class GetOrderScreen extends StatelessWidget {
  const GetOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: const Icon(
                Icons.shopping_cart_sharp,
                color: kPrimaryColor,
              ),
              title: const Text("My Orders"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: ShopAppCubit.get(context).getOrdersModel == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No order yet ",
                          style:
                              TextStyle(fontSize: 30, color: Colors.grey[400]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.shopping_cart_sharp,
                          color: Colors.grey[200],
                          size: 100,
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView.separated(
                        itemBuilder: (context, index) => itemOrders(
                            ShopAppCubit.get(context).getOrdersModel!,
                            index,
                            context),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: ShopAppCubit.get(context)
                            .getOrdersModel!
                            .data!
                            .data
                            .length),
                  ),
          );
        });
  }

  Widget itemOrders(GetOrdersModel model, index, context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ' ID    :    ${model.data!.data[index].id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                const Spacer(),
                if (model.data!.data[index].status == "New")
                  Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: MaterialButton(
                        onPressed: () {
                          ShopAppCubit.get(context).cancelOrder(
                              orderId: model.data!.data[index].id!);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                  )
              ],
            ),
            Text(
              ' Total  :   ${model.data!.data[index].total}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(height: 10),
            Text(
              ' Date   :  ${model.data!.data[index].date}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Status  : ", style: textStyle),
                Text(
                  " ${model.data!.data[index].status}",
                  style: textStyle.copyWith(
                      color: model.data!.data[index].status == "New"
                          ? Colors.green
                          : Colors.red),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
