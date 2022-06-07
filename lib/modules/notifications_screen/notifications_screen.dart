import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../layout/cubit/cubit.dart';
import '../../../../layout/cubit/states.dart';
import '../../../models/notifications_model.dart';
import '../../../shard/component/component.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        NotificationsModel model = ShopAppCubit.get(context).notifications!;
        return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            leading: appBarLeading(context),
            title: const Text(
              "Notifications",
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.notifications_active_outlined),
              )
            ],
          ),
          body: state is ShopAppGetNotificationsLoadingState
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemBuilder: (context, index) =>
                      notificationsItem(context, model, index),
                  separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                  itemCount: model.data!.data!.length),
        );
      },
    );
  }

  Widget notificationsItem(context, NotificationsModel model, index) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  "13:02:24",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Spacer(),
                Text("2022:02:27",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 15,
                    ))
              ],
            ),
            const SizedBox(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Text(
              "${model.data!.data![index].title} ",
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${model.data!.data![index].message}",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
