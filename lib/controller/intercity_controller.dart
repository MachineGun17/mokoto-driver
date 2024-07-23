import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/controller/home_intercity_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/intercity_order_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IntercityController extends GetxController {
  HomeIntercityController homeController = Get.put(HomeIntercityController());

  Rx<TextEditingController> sourceCityController = TextEditingController().obs;
  Rx<TextEditingController> destinationCityController = TextEditingController().obs;
  Rx<TextEditingController> whenController = TextEditingController().obs;
  Rx<TextEditingController> suggestedTimeController = TextEditingController().obs;
  DateTime? suggestedTime = DateTime.now();
  DateTime? dateAndTime = DateTime.now();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  RxList<InterCityOrderModel> intercityServiceOrder = <InterCityOrderModel>[].obs;
  RxBool isLoading = false.obs;
  RxString newAmount = "0.0".obs;
  Rx<TextEditingController> enterOfferRateController = TextEditingController().obs;

  Rx<DriverUserModel> driverModel = DriverUserModel().obs;

  getOrder() async {
    isLoading.value = true;
    intercityServiceOrder.clear();
    FireStoreUtils.fireStore.collection(CollectionName.driverUsers).doc(FireStoreUtils.getCurrentUid()).snapshots().listen((event) {
      if (event.exists) {
        driverModel.value = DriverUserModel.fromJson(event.data()!);
      }
    });
    if (destinationCityController.value.text.isNotEmpty) {
      if(whenController.value.text.isEmpty){
        await FireStoreUtils.fireStore
            .collection(CollectionName.ordersIntercity)
            .where('sourceCity', isEqualTo: sourceCityController.value.text)
            .where('destinationCity', isEqualTo: destinationCityController.value.text)
            .where('zoneId', whereIn: driverModel.value.zoneIds)
            .where('status', isEqualTo: Constant.ridePlaced)
            .get()
            .then((value) {
          isLoading.value = false;

          for (var element in value.docs) {
            InterCityOrderModel documentModel = InterCityOrderModel.fromJson(element.data());
            if (documentModel.acceptedDriverId != null && documentModel.acceptedDriverId!.isNotEmpty) {
              if (!documentModel.acceptedDriverId!.contains(FireStoreUtils.getCurrentUid())) {
                intercityServiceOrder.add(documentModel);
              }
            } else {
              intercityServiceOrder.add(documentModel);
            }
          }
        });
      }else{
        await FireStoreUtils.fireStore
            .collection(CollectionName.ordersIntercity)
            .where('sourceCity', isEqualTo: sourceCityController.value.text)
            .where('destinationCity', isEqualTo: destinationCityController.value.text)
            .where('whenDates', isEqualTo: DateFormat("dd-MMM-yyyy").format(dateAndTime!))
            .where('zoneId', whereIn: driverModel.value.zoneIds)
            .where('status', isEqualTo: Constant.ridePlaced)
            .get()
            .then((value) {
          isLoading.value = false;

          for (var element in value.docs) {
            InterCityOrderModel documentModel = InterCityOrderModel.fromJson(element.data());
            if (documentModel.acceptedDriverId != null && documentModel.acceptedDriverId!.isNotEmpty) {
              if (!documentModel.acceptedDriverId!.contains(FireStoreUtils.getCurrentUid())) {
                intercityServiceOrder.add(documentModel);
              }
            } else {
              intercityServiceOrder.add(documentModel);
            }
          }
        });
      }
    } else {
      if(whenController.value.text.isEmpty){
        await FireStoreUtils.fireStore
            .collection(CollectionName.ordersIntercity)
            .where('sourceCity', isEqualTo: sourceCityController.value.text)
            .where('zoneId', whereIn: driverModel.value.zoneIds)
            .where('status', isEqualTo: Constant.ridePlaced)
            .get()
            .then((value) {
          isLoading.value = false;
          for (var element in value.docs) {
            InterCityOrderModel documentModel = InterCityOrderModel.fromJson(element.data());
            if (documentModel.acceptedDriverId != null && documentModel.acceptedDriverId!.isNotEmpty) {
              if (!documentModel.acceptedDriverId!.contains(FireStoreUtils.getCurrentUid())) {
                intercityServiceOrder.add(documentModel);
              }
            } else {
              intercityServiceOrder.add(documentModel);
            }
          }
          print(value.docs.length);
        });
      }else{
        await FireStoreUtils.fireStore
            .collection(CollectionName.ordersIntercity)
            .where('sourceCity', isEqualTo: sourceCityController.value.text)
            .where('whenDates', isEqualTo: DateFormat("dd-MMM-yyyy").format(dateAndTime!))
            .where('status', isEqualTo: Constant.ridePlaced)
            .get()
            .then((value) {
          isLoading.value = false;
          for (var element in value.docs) {
            InterCityOrderModel documentModel = InterCityOrderModel.fromJson(element.data());
            if (documentModel.acceptedDriverId != null && documentModel.acceptedDriverId!.isNotEmpty) {
              if (!documentModel.acceptedDriverId!.contains(FireStoreUtils.getCurrentUid())) {
                intercityServiceOrder.add(documentModel);
              }
            } else {
              intercityServiceOrder.add(documentModel);
            }
          }
          print(value.docs.length);
        });
      }
    }


  }
}
