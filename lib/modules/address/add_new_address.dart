import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../layout/cubit/states.dart';
import '../../../shard/component/component.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/size_config.dart';

class AddNewAddress extends StatelessWidget {
  final bool isUpdate;
  final String? name;
  final String? city;
  final String? region;
  final String? details;
  final String? notes;
  final int? id;

  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  var addAddressFormKey = GlobalKey<FormState>();

  AddNewAddress(
      {Key? key,
      required this.isUpdate,
      this.name,
      this.city,
      this.region,
      this.details,
      this.notes,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopAppAddAddressSuccessState) {
          if (state.addressModel.status!) {
            showToast(
                text: state.addressModel.message!, state: ToastStates.SUCCESS);
            Navigator.pop(context);
          } else {
            showToast(
                text: state.addressModel.message!, state: ToastStates.ERROR);
          }
        } else if (state is ShopAppUpdateAddressSuccessState) {
          if (state.updateAddressModel!.status) {
            showToast(
                text: state.updateAddressModel!.message!,
                state: ToastStates.SUCCESS);
            Navigator.pop(context);
          } else {
            showToast(
                text: state.updateAddressModel!.message!,
                state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        if (isUpdate) {
          nameController.text = name!;
          cityController.text = city!;
          regionController.text = region!;
          detailsController.text = details!;
          notesController.text = notes!;
        }

        return Scaffold(
          appBar: AppBar(
            leading: appBarLeading(context),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: TextButton(
                    onPressed: () {
                      if (addAddressFormKey.currentState!.validate()) {
                        if (isUpdate) {
                          ShopAppCubit.get(context).updateAddress(
                              addressId: id,
                              name: nameController.text,
                              city: cityController.text,
                              region: regionController.text,
                              details: detailsController.text,
                              notes: notesController.text);
                        } else {
                          ShopAppCubit.get(context).addAddress(
                              name: nameController.text,
                              city: cityController.text,
                              region: regionController.text,
                              details: detailsController.text,
                              notes: notesController.text);
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                  key: addAddressFormKey,
                  child: Column(
                    children: [
                      if (state is ShopAppAddAddressLoadingState ||
                          state is ShopAppUpdateAddressSuccessState)
                        Column(
                          children: const [
                            LinearProgressIndicator(
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      Container(
                        padding: const EdgeInsetsDirectional.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Name',
                                style: TextStyle(fontSize: 15),
                              ),
                              buildTextFormField(
                                  text: "please enter location name",
                                  controller: nameController),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'City',
                                style: TextStyle(fontSize: 15),
                              ),
                              buildTextFormField(
                                  text: "please enter your city",
                                  controller: cityController),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'Region',
                                style: TextStyle(fontSize: 15),
                              ),
                              buildTextFormField(
                                  text: "Please enter your region",
                                  controller: regionController),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'Details',
                                style: TextStyle(fontSize: 15),
                              ),
                              buildTextFormField(
                                  text: 'Please enter some details',
                                  controller: detailsController),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'Notes',
                                style: TextStyle(fontSize: 15),
                              ),
                              buildTextFormField(
                                  text: 'Please add some notes',
                                  controller: notesController),
                              const SizedBox(
                                height: 20,
                              ),
                            ]),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  TextFormField buildTextFormField(
      {required String text, required TextEditingController controller}) {
    return TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
          border: const UnderlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field cant be Empty';
          }
        });
  }
}
