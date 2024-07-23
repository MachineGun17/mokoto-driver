import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/service_model.dart';
import 'package:driver/ui/intercity_screen/accepted_intercity_orders.dart';
import 'package:driver/ui/intercity_screen/active_intercity_order_screen.dart';
import 'package:driver/ui/intercity_screen/new_order_intercity_screen.dart';
import 'package:driver/ui/order_intercity_screen/order_intercity_screen.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeIntercityController extends GetxController {
  RxInt selectedIndex = 0.obs;
  List<Widget> widgetOptions = <Widget>[const NewOrderInterCityScreen(), const AcceptedIntercityOrders(), const ActiveIntercityOrderScreen(),const OrderIntercityScreen()];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getDriver();
    super.onInit();
  }

  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<ServiceModel> selectedService = ServiceModel().obs;
  RxBool isLoading = true.obs;

  getDriver() async {
    await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid()).then((value) {
      driverModel.value = value!;
      isLoading.value = false;
    });

    if (driverModel.value.serviceId != null) {
      await FireStoreUtils.getService().then((value) {
        value.forEach((element) {
          if (element.id == driverModel.value.serviceId) {
            selectedService.value = element;
          }
        });
      });
    }

    print(selectedService.toJson());
  }
}
