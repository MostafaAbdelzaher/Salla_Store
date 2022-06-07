import '../../models/add_address.dart';
import '../../models/cahnge_favorites_model.dart';
import '../../models/in_cart_model.dart';
import '../../models/login_model.dart';
import '../../models/update_address.dart';

abstract class ShopAppStates {}

class InitialState extends ShopAppStates {}

class ChangeBottomNavState extends ShopAppStates {}

class ShopLoadingHomeDataState extends ShopAppStates {}

class ShopSuccessHomeDataState extends ShopAppStates {}

class ShopErrorHomeDataState extends ShopAppStates {}

//Categories
class ShopLoadingCategoryDataState extends ShopAppStates {}

class ShopSuccessCategoryDataState extends ShopAppStates {}

class ShopErrorCategoryDataState extends ShopAppStates {}

class ChangeFavoritesIcon extends ShopAppStates {}

class ShopSuccessChangeFavoritesDataState extends ShopAppStates {
  final ChangeFavoritesModel? changeFavoritesModel;

  ShopSuccessChangeFavoritesDataState(this.changeFavoritesModel);
}

class ShopErrorChangeFavoritesDataState extends ShopAppStates {}

class ShopLoadingGetFavoritesDataState extends ShopAppStates {}

class ShopSuccessGetFavoritesDataState extends ShopAppStates {}

class ShopErrorGetFavoritesDataState extends ShopAppStates {}

class ShopGetInCartLoadingDataState extends ShopAppStates {}

class ShopGetInCartSuccessDataState extends ShopAppStates {}

class ShopGetInCartErrorDataState extends ShopAppStates {}

class ShopLoadingGetUserDataState extends ShopAppStates {}

class ShopSuccessGetUserDataState extends ShopAppStates {}

class ShopErrorGetUserDataState extends ShopAppStates {}

class ShopChangeInCartIconState extends ShopAppStates {}

class ShopSuccessInCartDataState extends ShopAppStates {
  late InCartChange inCartChange;
  ShopSuccessInCartDataState(this.inCartChange);
}

class ShopErrorInCartDataState extends ShopAppStates {}

class ShopLoadingUpdateDataState extends ShopAppStates {}

class ShopSuccessUpdateDataState extends ShopAppStates {
  final LoginModel? loginModel;

  ShopSuccessUpdateDataState(this.loginModel);
}

class ShopErrorUpdateDataState extends ShopAppStates {}

class ShopLoadingGetProductDetailsDataStats extends ShopAppStates {}

class ShopSuccessGetProductDetailsDataStats extends ShopAppStates {}

class ShopCategoryDetailsLoadingState extends ShopAppStates {}

class ShopCategoryDetailsSuccessState extends ShopAppStates {}

class ShopCategoryDetailsErrorState extends ShopAppStates {}

class ShoErrorGetProductDetailsDataState extends ShopAppStates {}

class ShopLoadingSearchDataStatus extends ShopAppStates {}

class ShopSuccessSearchDataStatus extends ShopAppStates {}

class ShoErrorSearchDataState extends ShopAppStates {}

class ChangeIndicatorState extends ShopAppStates {}

//upDate in cart data
class ShopAppUpdateInCartDataLoading extends ShopAppStates {}

class ShopAppUpdateInCartDataError extends ShopAppStates {}

class ShopAppUpdateInCartPlusQuantity extends ShopAppStates {}

class ShopAppUpdateInCartMinusQuantity extends ShopAppStates {}

//Add Address
class ShopAppAddAddressLoadingState extends ShopAppStates {}

class ShopAppAddAddressSuccessState extends ShopAppStates {
  final AddAddressModel addressModel;

  ShopAppAddAddressSuccessState(this.addressModel);
}

class ShopAppAddAddressErrorState extends ShopAppStates {}

//Get Address
class ShopAppGetAddressLoadingState extends ShopAppStates {}

class ShopAppGetAddressSuccessState extends ShopAppStates {}

class ShopAppGetAddressErrorState extends ShopAppStates {}

//Delete Address
class ShopAppDeleteAddressLoadingState extends ShopAppStates {}

class ShopAppDeleteAddressSuccessState extends ShopAppStates {}

class ShopAppDeleteAddressErrorState extends ShopAppStates {}

//update Address
class ShopAppUpdateAddressLoadingState extends ShopAppStates {}

class ShopAppUpdateAddressSuccessState extends ShopAppStates {
  final UpdateAddressModel? updateAddressModel;

  ShopAppUpdateAddressSuccessState(this.updateAddressModel);
}

class ShopAppUpdateAddressErrorState extends ShopAppStates {}

// add orders
class ShopAppAddOrdersSuccessState extends ShopAppStates {}

class ShopAppAddOrdersErrorState extends ShopAppStates {}

// Get orders
class ShopAppGetOrdersSuccessState extends ShopAppStates {}

class ShopAppGetOrdersErrorState extends ShopAppStates {}

//Get Faqs
class ShopAppGetFaqsSuccessState extends ShopAppStates {}
//Get Notifications

class ShopAppGetNotificationsLoadingState extends ShopAppStates {}

class ShopAppGetNotificationsSuccessState extends ShopAppStates {}

class ShopAppGetNotificationsErrorState extends ShopAppStates {}

class ShopAppGetFaqsErrorState extends ShopAppStates {}
// Cancel orders

class ShopAppCancelOrdersSuccessState extends ShopAppStates {}

class ShopAppCancelOrdersErrorState extends ShopAppStates {}

class ChangeIconThem extends ShopAppStates {}

class ChangeSeeMore extends ShopAppStates {}
