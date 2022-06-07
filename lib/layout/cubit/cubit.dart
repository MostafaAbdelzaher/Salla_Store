import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla_app/layout/cubit/states.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../models/InCart_Get_model.dart';
import '../../../models/add_address.dart';
import '../../../models/cahnge_favorites_model.dart';
import '../../../models/categories_details.dart';
import '../../../models/categories_model.dart';
import '../../../models/delete_address.dart';
import '../../../models/detail_model.dart';
import '../../../models/faqs_model.dart';
import '../../../models/favorites_mode.dart';
import '../../../models/get_address.dart';
import '../../../models/home_model.dart';
import '../../../models/in_cart_model.dart';
import '../../../models/login_model.dart';
import '../../../models/notifications_model.dart';
import '../../../models/orders_model.dart';
import '../../../models/search_model.dart';
import '../../../models/update_address.dart';
import '../../../modules/In_cart_screen/In_cart_screen.dart';
import '../../../modules/categories/categories_screen.dart';
import '../../../modules/favorites/favorite_screen.dart';
import '../../../modules/home/home_Screen.dart';
import '../../../modules/setteings/settings_screen.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/network/local/cache_helper.dart';
import '../../../shard/network/remote/end_points.dart';
import '../../../shard/network/remote/dio_helper.dart';

class ShopAppCubit extends Cubit<ShopAppStates> {
  ShopAppCubit() : super(InitialState());
  static ShopAppCubit get(context) => BlocProvider.of(context);
  bool seeMore = false;
  void changeSeeMore() {
    seeMore = !seeMore;
    emit(ChangeSeeMore());
  }

  List<Widget> screen = [
    const HomeScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
    InCartScreen(),
    SettingsScreen(),
  ];
  int currentIndex = 0;
  List<SalomonBottomBarItem> navList = [
    SalomonBottomBarItem(
        icon: const Icon(Icons.home),
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: const Icon(Icons.apps),
        title: const Text(
          "Categories",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: const Icon(Icons.favorite),
        title: const Text(
          "Favorite",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: const Icon(Icons.shopping_cart_sharp),
        title: const Text(
          "Carts",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: const Icon(Icons.settings),
        title: const Text(
          "settings",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
  ];
  void changeIndex(int index) {
    currentIndex = index;

    emit(ChangeBottomNavState());
  }

  //GetHomeData
  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  Map<int, bool> carts = {};
  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products) {
        favorites.addAll({element.id: element.inFavorites});
      }
      for (var element in homeModel!.data!.products) {
        carts.addAll({element.id: element.inCart});
      }

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print("${error.toString()} getHomeData error");
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    emit(ShopLoadingCategoryDataState());
    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoryDataState());
    }).catchError((error) {
      print("${error.toString()} getCategoriesData error");

      emit(ShopErrorCategoryDataState());
    });
  }

//Get CategoryDetailData
  CategoryDetailModel? categoriesDetailModel;
  void getCategoriesDetailData(int? categoryID) {
    emit(ShopCategoryDetailsLoadingState());
    DioHelper.getData(url: CATEGORIES_DETAIL, query: {
      'category_id': '$categoryID',
    }).then((value) {
      categoriesDetailModel = CategoryDetailModel.fromJson(value.data);
      emit(ShopCategoryDetailsSuccessState());
    }).catchError((error) {
      emit(ShopCategoryDetailsErrorState());
      print(error.toString());
    });
  }

//Get ProductDetailsData
  ProductDetailsModel? productDetailsModel;
  void getDetailsProduct(String id) {
    emit(ShopLoadingGetProductDetailsDataStats());
    DioHelper.getData(
            url: 'products/$id', token: CacheHelper.getData(key: 'token'))
        .then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(ShopSuccessGetProductDetailsDataStats());
    }).catchError((error) {
      print("${error.toString()} getProductDetailsData error");
      print(error.toString());
    });
  }

//changeFavorites
  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(ChangeFavoritesIcon());
    DioHelper.postData(
            url: FAVORITES,
            data: {"product_id": productId},
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangeFavoritesDataState(changeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      print("${error.toString()} changeFavoritesModel error");

      emit(ShopErrorChangeFavoritesDataState());
    });
  }

// InCartChange
  InCartChange? inCartChange;
  void inCarts(int productId) {
    carts[productId] = !carts[productId]!; //Change bool
    emit(ShopChangeInCartIconState());
    DioHelper.postData(
            url: CARTS,
            data: {"product_id": productId},
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      inCartChange = InCartChange.fromJson(value.data);
      if (!inCartChange!.status!) {
        carts[productId] = !carts[productId]!;
      } else {
        getInCartData();
      }
      emit(ShopSuccessInCartDataState(inCartChange!));
    }).catchError((onError) {
      carts[productId] = !carts[productId]!;
      print(onError.toString());
      emit(ShopErrorInCartDataState());
    });
  }

//getFavoritesData
  FavoritesModel? favoritesModel;
  void getFavoritesData() {
    emit(ShopLoadingGetFavoritesDataState());
    DioHelper.getData(url: FAVORITES, token: CacheHelper.getData(key: 'token'))
        .then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesDataState());
    }).catchError((error) {
      print("${error.toString()} getFavoritesModel error");
      emit(ShopErrorGetFavoritesDataState());
    });
  }

//InCartGetData
  InCartGetModel? inCartGetModel;
  void getInCartData() {
    emit(ShopGetInCartLoadingDataState());
    DioHelper.getData(url: CARTS, token: CacheHelper.getData(key: 'token'))
        .then((value) {
      inCartGetModel = InCartGetModel.fromJson(value.data);
      print("${inCartGetModel!.message} inCartGetError");
      emit(ShopGetInCartSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetInCartErrorDataState());
    });
  }

//GetUerData
  LoginModel? userModel;
  void getUserData() {
    emit(ShopLoadingGetUserDataState());
    DioHelper.getData(url: PROFILES, token: CacheHelper.getData(key: 'token'))
        .then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(ShopSuccessGetUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserDataState());
    });
  }

//UpdateUserData
  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateDataState());
    DioHelper.putData(
        url: UPDATE_PROFILE,
        token: CacheHelper.getData(key: 'token'),
        data: {
          'name': name,
          'email': email,
          'phone': phone,
        }).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(userModel!.data!.phone!);
      emit(ShopSuccessUpdateDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateDataState());
    });
  }

//GetSearchData
  SearchModel? searchModel;
  void getSearchData(String text) {
    emit(ShopLoadingSearchDataStatus());
    DioHelper.postData(
            data: {text: 'text'},
            url: SEARCH,
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSuccessSearchDataStatus());
    }).catchError((error) {
      emit(ShoErrorSearchDataState());
      print(error.toString());
    });
  }

//plus and minus Quantity Item InCart
  int quantity = 1;
  void plusQuantity(InCartGetModel model, int index) {
    quantity = model.data!.cartItems[index].quantity!;
    quantity++;
    emit(ShopAppUpdateInCartPlusQuantity());
  }

  void minusQuantity(InCartGetModel model, int index) {
    quantity = model.data!.cartItems[index].quantity!;
    if (quantity >= 1) quantity--;
    emit(ShopAppUpdateInCartMinusQuantity());
  }

//Up date cart data
  void updateCartData({required String id, int? quantity}) {
    emit(ShopAppUpdateInCartDataLoading());
    DioHelper.putData(
            url: "carts/" + id,
            data: {
              'quantity': quantity,
            },
            token: CacheHelper.getData(key: "token"))
        .then((value) {
      getInCartData();
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppUpdateInCartDataError());
    });
  }

// post Address to order
  AddAddressModel? addressModel;
  void addAddress({
    required String name,
    required String city,
    required String region,
    required String details,
    required String notes,
    double latitude = 30.0616863,
    double longitude = 31.3260088,
  }) {
    emit(ShopAppAddAddressLoadingState());
    DioHelper.postData(
      url: ADDRESS,
      data: {
        'name': name,
        'city': city,
        'region': region,
        'details': details,
        'notes': notes,
        'latitude': latitude,
        'longitude': longitude,
      },
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      addressModel = AddAddressModel.fromJson(value.data);
      if (addressModel!.status!) getAddresses();
      emit(ShopAppAddAddressSuccessState(addressModel!));
    }).catchError((error) {
      emit(ShopAppAddAddressErrorState());
    });
  }

// get Address to order
  GetAddressModel? getAddressModel;
  void getAddresses() {
    emit(ShopAppGetAddressLoadingState());
    DioHelper.getData(
      url: ADDRESS,
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      getAddressModel = GetAddressModel.fromJson(value.data);
      emit(ShopAppGetAddressSuccessState());
    }).catchError((error) {
      emit(ShopAppGetAddressErrorState());
    });
  }

// Delete Address
  DeleteAddress? deleteAddress;
  void removeAddress({required addressId}) {
    emit(ShopAppDeleteAddressLoadingState());
    DioHelper.deleteData(
      url: 'addresses/$addressId',
      token: token,
    ).then((value) {
      deleteAddress = DeleteAddress.fromJson(value.data);
      if (deleteAddress!.status!) getAddresses();
      emit(ShopAppDeleteAddressSuccessState());
    }).catchError((error) {
      emit(ShopAppDeleteAddressErrorState());
      print(error.toString());
    });
  }

// Update address
  UpdateAddressModel? updateAddressModel;
  void updateAddress({
    required addressId,
    required String name,
    required String city,
    required String region,
    required String details,
    required String notes,
    double latitude = 30.0616863,
    double longitude = 31.3260088,
  }) {
    emit(ShopAppUpdateAddressLoadingState());
    DioHelper.putData(
      url: 'addresses/$addressId',
      data: {
        'name': name,
        'city': city,
        'region': region,
        'details': details,
        'notes': notes,
        'latitude': latitude,
        'longitude': longitude,
      },
      token: token,
    ).then((value) {
      updateAddressModel = UpdateAddressModel.fromJson(value.data);
      if (updateAddressModel!.status) getAddresses();
      emit(ShopAppUpdateAddressSuccessState(updateAddressModel));
    }).catchError((error) {
      emit(ShopAppUpdateAddressErrorState());
      print(error.toString());
    });
  }

  // Add order
  AddAddressModel? addAddressModel;
  void addOrders({
    addressId,
  }) {
    DioHelper.postData(
      url: ORDERS,
      data: {
        'address_id': addressId,
        'payment_method': 1,
        'use_points': false,
      },
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      getOrders();
      addAddressModel = AddAddressModel.fromJson(value.data);
      emit(ShopAppAddOrdersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppAddOrdersErrorState());
    });
  }

  // Get order
  GetOrdersModel? getOrdersModel;
  void getOrders() {
    DioHelper.getData(
      url: ORDERS,
      token: CacheHelper.getData(key: "token"),
    ).then((
      value,
    ) {
      getOrdersModel = GetOrdersModel.fromJson(value.data);
      emit(ShopAppGetOrdersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppGetOrdersErrorState());
    });
  }

  // Get faqs
  FAQsModel? faQsModel;
  void getFaqs() {
    DioHelper.getData(
      url: FAQS,
    ).then((
      value,
    ) {
      faQsModel = FAQsModel.fromJson(value.data);
      emit(ShopAppGetFaqsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppGetFaqsErrorState());
    });
  }

  // Get Notifications
  NotificationsModel? notifications;
  void getNotifications() {
    emit(ShopAppGetNotificationsLoadingState());

    DioHelper.getData(url: NOTIFICATIONS, token: token).then((
      value,
    ) {
      notifications = NotificationsModel.fromJson(value.data);
      emit(ShopAppGetNotificationsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppGetNotificationsErrorState());
    });
  }

  // Cancel order
  CancelOrderModel? cancelOrderModel;
  void cancelOrder({required int orderId}) {
    DioHelper.getData(
      url: "$ORDERS $orderId cancel ",
      token: CacheHelper.getData(key: "token"),
    ).then((
      value,
    ) {
      cancelOrderModel = CancelOrderModel.fromJson(value.data);
      getOrders();
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppCancelOrdersErrorState());
    });
  }

  IconData changeIcon = Icons.toggle_on;
  bool isDark = false;
  void changeThemMod() {
    isDark = !isDark;
    changeIcon = isDark == false ? Icons.toggle_on : Icons.toggle_off;
    emit(ChangeIconThem());
  }
}
