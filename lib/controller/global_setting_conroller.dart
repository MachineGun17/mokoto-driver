import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/model/currency_model.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/language_model.dart';
import 'package:driver/services/localization_service.dart';
import 'package:driver/utils/Preferences.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    notificationInit();
    getCurrentCurrency();
    super.onInit();
  }

  getCurrentCurrency() async {
    if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
      LanguageModel languageModel = Constant.getLanguage();
      LocalizationService().changeLocale(languageModel.code.toString());
    }
    await FireStoreUtils().getGoogleAPIKey();

    await FireStoreUtils().getCurrency().then((value) {
      print("VALOR DE DIVISA EN GLOBAL CONTROLLER");
      print(value);
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "64807d6956651", code: "USD", decimalDigits: 2, enable: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
      }
    });
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");

      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid()).then((value) {
          if (value != null) {
            print("VALOR DE DRIVER USER");
            DriverUserModel driverUserModel = value;
            driverUserModel.fcmToken = token;
            driverUserModel.walletAmount = value.walletAmount;
            print("TOKEN DE DRIVER USER ${driverUserModel.fcmToken}");
            print("WALLET DE DRIVER USER ${driverUserModel.walletAmount}");
            FireStoreUtils.updateDriverUser(driverUserModel);
          }
        });
      }
    });
  }
}
