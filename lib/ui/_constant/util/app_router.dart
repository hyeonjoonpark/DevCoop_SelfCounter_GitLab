import 'package:counter/ui/barcode/barcode_page.dart';
import 'package:counter/ui/check/check_student.dart';
import 'package:counter/ui/home/home.dart';
import 'package:counter/ui/payments/payments_page.dart';
import 'package:counter/ui/pin/pin_change.dart';
import 'package:counter/ui/pin/pin_page.dart';
import 'package:get/get.dart';

List<GetPage> appRouter = [
  GetPage(
    name: '/',
    page: () => Home(),
  ),
  GetPage(
    name: "/barcode",
    page: () => const BarcodePage(),
  ),
  GetPage(
    name: "/check",
    page: () => const CheckStudent(),
  ),
  GetPage(
    name: "/payments",
    page: () => const PaymentsPage(),
  ),
  GetPage(
    name: "/pin",
    page: () => PinPage(codeNumber: Get.arguments as String),
  ),
  GetPage(
    name: "/pin/change",
    page: () => const PinChange(),
  )
];
