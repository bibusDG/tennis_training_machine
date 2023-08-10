import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:tennis_training_machine/controllers/blue_controller.dart';

class BleDevices extends StatelessWidget {
  const BleDevices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlueController blueController = Get.put(BlueController());
    connectToDevice();


    // connectToDevice();
    return Scaffold(
      body: Obx(() {
        return Center(
          child: SizedBox(
            child: blueController.blueDevices.length > 1 ?
            RefreshIndicator(
              onRefresh: () async{
                connectToDevice();
              },
              child: ListView.builder(
                  itemExtent: 30.0,
                  itemCount: blueController.blueDevices.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      child: Text(blueController.blueDevices[index]),
                    );
              }),
            ) :
            const Center(child: CircularProgressIndicator()),
          ),
        );
      }),
    );
  }

  connectToDevice() {

    BlueController blueController = Get.find();
    blueController.flutterBlue.startScan(timeout: const Duration(seconds: 4));


    blueController.flutterBlue.scanResults.listen((results) async {
      blueController.blueDevices.value = [];
      for (ScanResult scan in results) {
        if(blueController.blueDevices.contains(scan.device.name)){

        }else{
          if(scan.device.name != ''){
            blueController.blueDevices.add(scan.device.name);
          }
        }
        // if (r.rssi == 1) {
        //   blueController.blueDevices.add(r.rssi);
        //   blueController.flutterBlue.stopScan();
        //   // Connect to the device
        //   await r.device.connect();
        //   // Disconnect from device
        //   r.device.disconnect();
        // }
      }
    });
  }

}
