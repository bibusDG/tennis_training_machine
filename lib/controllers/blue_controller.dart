import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BlueController extends GetxController{
  FlutterBlue flutterBlue = FlutterBlue.instance;
  RxList blueDevices = [].obs;
}