import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennis_training_machine/pages/ble_devices.dart';
import 'package:tennis_training_machine/pages/my_trainings_page.dart';
import 'package:tennis_training_machine/pages/training_setup_page.dart';
import 'dart:ui' as UI;

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return ResponsiveScaledBox(
      width: 360,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(onPressed: (){
                Get.defaultDialog(
                  title: 'Training devices',
                  content: const SizedBox(
                    width: 300,
                      height: 500,
                      child: BleDevices()),
                );
              }, icon: const Icon(Icons.bluetooth_connected_rounded)),
              const SizedBox(width: 10.0,)
            ],
            title: const Text('Start page'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(child: const Text('My trainings'), onPressed: () async{
                  await GetStorage.init('myTrainings');
                  Get.to(()=>const MyTrainingsPage());
                }),
                const SizedBox(height: 20.0,),
                CupertinoButton(child: const Text('Create new training'), onPressed: (){
                  Get.to(()=>const TrainingSetUpPage());
                })
              ],
            ),
          ),
        ));
  }
}
