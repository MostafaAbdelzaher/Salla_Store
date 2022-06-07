import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../models/get_address.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import 'add_new_address.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          bool isEmpty =
              ShopAppCubit.get(context).getAddressModel!.data!.data!.isEmpty;
          bool isNotEmpty =
              ShopAppCubit.get(context).getAddressModel!.data!.data!.isNotEmpty;

          return Scaffold(
            appBar: AppBar(
              leading: const Icon(
                Icons.add_location,
                color: kPrimaryColor,
              ),
              title: const Text("Address"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => addressBuilder(
                            ShopAppCubit.get(context).getAddressModel!,
                            index,
                            context),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: ShopAppCubit.get(context)
                            .getAddressModel!
                            .data!
                            .data!
                            .length),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        color: kPrimaryColor,
                        onPressed: () {
                          navigateTo(
                              context,
                              AddNewAddress(
                                isUpdate: false,
                              ));
                        },
                        child: const Text(
                          "Add New Address",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  if (isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        color: kPrimaryColor,
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            animType: AnimType.SCALE,
                            title: ' Confirm this Order ',
                            btnOkOnPress: () {
                              ShopAppCubit.get(context).addOrders(
                                  addressId: ShopAppCubit.get(context)
                                      .getAddressModel!
                                      .data!
                                      .data!
                                      .first
                                      .id);
                              ShopAppCubit.get(context).getOrders();
                            },
                            btnCancelText: "Cancel",
                            btnOkText: "Confirm",
                            btnCancelOnPress: () {},
                          ).show();
                        },
                        child: const Text(
                          "Order",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget addressBuilder(GetAddressModel model, index, context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ' Name    :     ${model.data!.data![index].name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    navigateTo(
                        context,
                        AddNewAddress(
                          isUpdate: true,
                          city: model.data!.data![index].city,
                          details: model.data!.data![index].details,
                          name: model.data!.data![index].name,
                          notes: model.data!.data![index].notes,
                          region: model.data!.data![index].region,
                          id: model.data!.data![index].id,
                        ));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 10,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              ' City        :     ${model.data!.data![index].city}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              ' Region   :    ${model.data!.data![index].region}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              ' Details   :     ${model.data!.data![index].details}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  ' Notes     :     ${model.data!.data![index].notes}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    ShopAppCubit.get(context)
                        .removeAddress(addressId: model.data!.data![index].id);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 15,
                      ),
                      Text(
                        ' Delete',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
