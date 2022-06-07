import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../models/InCart_Get_model.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/size_config.dart';
import '../address/address_screen.dart';
import '../product_details/product_details.dart';

class InCartScreen extends StatelessWidget {
  final bool? fromNotification;
  const InCartScreen({Key? key, this.fromNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: fromNotification == true
              ? AppBar(leading: appBarLeading(context))
              : null,
          body: Padding(
            padding: EdgeInsets.only(top: fromNotification != true ? 35.0 : 0),
            child: ConditionalBuilder(
                condition: ShopAppCubit.get(context).inCartGetModel != null,
                builder: (context) => Column(children: [
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) => inCartItem(
                                ShopAppCubit.get(context).inCartGetModel!,
                                context,
                                index),
                            separatorBuilder: (context, index) => separated(),
                            itemCount: ShopAppCubit.get(context)
                                .inCartGetModel!
                                .data!
                                .cartItems
                                .length),
                      ),
                      if (fromNotification != true)
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                          child: ListTile(
                            title: const Text('Total',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                '${ShopAppCubit.get(context).inCartGetModel!.data!.total} EG',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                            trailing: defaultButton(
                                height: 50,
                                text: "Check out",
                                width: 200,
                                function: () {
                                  navigateTo(context, const AddressScreen());
                                }),
                          ),
                        ),
                    ]),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator())),
          ),
        );
      },
    );
  }
}

Widget inCartItem(InCartGetModel model, BuildContext context, int index) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, top: 10),
    child: InkWell(
      onTap: () {
        navigateTo(
            context,
            ProductDetailsScreen(
              id: model.data!.cartItems[index].product!.id!,
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: getProportionateScreenWidth(90),
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  model.data!.cartItems[index].product!.image.toString(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.data!.cartItems[index].product!.name!,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black, fontSize: 14)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                          text:
                              "\$${model.data!.cartItems[index].product!.price.round()}",
                          style: const TextStyle(color: kPrimaryColor),
                          children: [
                            TextSpan(
                                text:
                                    "   / ${model.data!.cartItems[index].quantity}",
                                style: Theme.of(context).textTheme.caption)
                          ]),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.020),
                          borderRadius: BorderRadius.circular(13)),
                      child: Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              ShopAppCubit.get(context)
                                  .minusQuantity(model, index);
                              ShopAppCubit.get(context).updateCartData(
                                  id: model.data!.cartItems[index].id
                                      .toString(),
                                  quantity: ShopAppCubit.get(context).quantity);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/remove.svg",
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              ShopAppCubit.get(context)
                                  .plusQuantity(model, index);
                              ShopAppCubit.get(context).updateCartData(
                                  id: model.data!.cartItems[index].id
                                      .toString(),
                                  quantity: ShopAppCubit.get(context).quantity);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/Plus Icon.svg",
                                height: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ShopAppCubit.get(context).inCarts(
                                  model.data!.cartItems[index].product!.id!);
                            },
                            icon: const Icon(Icons.shopping_cart_outlined),
                            color: ShopAppCubit.get(context).carts[
                                    model.data!.cartItems[index].product!.id!]!
                                ? kPrimaryColor
                                : Colors.black,
                            focusColor: Colors.grey,
                            iconSize: 22,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
