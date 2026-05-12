import 'package:codelearn/services/dummy_data_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../view/course/payment/widgets/payment_success_dialog.dart';

class PaymentService {
  static void processPayment({
    required GlobalKey<FormState> formKey,
    required String courseId,
  }) {
    if (formKey.currentState!.validate()) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      //simulates payment processing
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();

        //add the course to purchased courses
        DummyDataService.addPurchasedCourse(courseId);

        Get.dialog(const PaymentSuccessDialog(), barrierDismissible: false);
      });
    }
  }
}
