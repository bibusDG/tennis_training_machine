import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennis_training_machine/controllers/bottom_navigation_bar_controller.dart';
import 'package:tennis_training_machine/controllers/return_hit_controller.dart';
import 'package:tennis_training_machine/controllers/total_ball_controller.dart';
import 'package:tennis_training_machine/models/return_hit_model.dart';
import 'package:tennis_training_machine/models/training_model.dart';


class TrainingSetUpPage extends StatelessWidget {
  const TrainingSetUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myTrainings = GetStorage('myTrainings');

    TrainingModel trainingModel = TrainingModel(name: 'first', returnHits: []);
    ReturnHitController returnHitController = Get.put(ReturnHitController());
    TotalBallController totalBallController = Get.put(TotalBallController());
    BottomNavigationBarController bottomNavigationBarController = Get.put(BottomNavigationBarController());
    totalBallController.totalBallValue.value = 60;

    Future<ui.Image> _loadImage(String imageAssetPath) async {
      final ByteData data = await rootBundle.load(imageAssetPath);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetHeight: 22,
        targetWidth: 22,
      );
      var frame = await codec.getNextFrame();
      return frame.image;
    }

    return ResponsiveScaledBox(
      width: 360,
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: const Text('Training page'),
            centerTitle: true,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: bottomNavigationBarController.navigationBarIndex.value,
            onTap: (index) {
              bottomNavigationBarController.navigationBarIndex.value = index;
              if (index == 0) {
                Get.back();
              } else if (index == 1) {
                returnHitController.positionChangeActivated.value = true;
              }
              else {
                List listOfJsonHits = [];
                for (ReturnHitModel element in trainingModel.returnHits) {
                  listOfJsonHits.add(element.toJson());
                }
                TextEditingController trainingName = TextEditingController();
                Get.defaultDialog(
                  title: 'Insert training name',
                  content: Column(
                    children: [
                      const SizedBox(height: 10.0,),
                      CupertinoTextField(
                        controller: trainingName,
                      ),
                      const SizedBox(height: 20.0,),
                      Row(
                        children: [
                          CupertinoButton(child: const Text('Cancel'), onPressed: () {
                            Get.back();
                          }),
                          const SizedBox(width: 30.0,),
                          CupertinoButton(child: const Text('Save'), onPressed: () {
                            myTrainings.write(trainingName.text, listOfJsonHits);
                            listOfJsonHits = [];
                            Get.back();
                            Get.back();
                          })
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_back_ios), label: 'Go back'),
              BottomNavigationBarItem(icon: Icon(Icons.compare_arrows_rounded), label: 'Ball position'),
              BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Save training'),
            ],),
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Balls left:', style: TextStyle(fontSize: 25.0, color: Colors.white),),
                    const SizedBox(width: 20.0,),
                    Text(totalBallController.totalBallValue.value.toString(), style: const TextStyle(color: Colors.white, fontSize: 30),),
                  ],
                ),
                const SizedBox(height: 10.0,),
                Expanded(
                  child: Center(
                    child: FutureBuilder(
                      future: _loadImage('assets/images/tennis_ball.png'),
                      builder: (BuildContext myContext, AsyncSnapshot ballImage) {
                        if (ballImage.hasData) {
                          return Container(
                            width: 360,
                            height: 400,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/half_court_red.png'),
                                    fit: BoxFit.fitWidth
                                )
                            ),
                            // width: 360,
                            // height: 533,
                            child: GestureDetector(
                              onHorizontalDragDown: (details) {

                                if (returnHitController.positionChangeActivated.value == false) {
                                  returnHitController.onInit();

                                  // RenderBox referenceBox = context.findRenderObject() as RenderBox;
                                  // var _offset = referenceBox.globalToLocal(event.localPosition);
                                  // print(_offset);

                                  var existingBallPressed = userPressedOnExistingBall(details.localPosition, trainingModel);

                                  if (existingBallPressed != null) {
                                    ReturnHitModel returnHit = existingBallPressed;
                                    returnHitController.editingExistingBall.value = true;
                                    returnHitController.editingHitCounter.value = returnHit.repeatBall;
                                    returnHitController.setReturnHitController(returnHit);
                                    openReturnHitParametersWindow(returnHitController, trainingModel, totalBallController);
                                  } else {
                                    returnHitController.hitCounter.value ++;

                                    ///
                                    returnHitController.newHit.ballPositionX = details.localPosition.dx;
                                    returnHitController.newHit.ballPositionY = details.localPosition.dy;

                                    ///

                                    returnHitController.hitConfirmed.value = true;
                                    returnHitController.refreshReturnHit();
                                    openReturnHitParametersWindow(returnHitController, trainingModel, totalBallController);
                                  }
                                }else{
                                  var existingBallPressed = userPressedOnExistingBall(details.localPosition, trainingModel);
                                  if (existingBallPressed != null) {
                                    ReturnHitModel returnHit = existingBallPressed;
                                    returnHitController.pressedBallNumber.value = returnHit.hitNumber;
                                  }
                                }
                              },

                              onHorizontalDragEnd: (details) {
                                returnHitController.positionChangeActivated.value = false;
                              },


                              onHorizontalDragUpdate: (details) {

                                if (returnHitController.positionChangeActivated.value) {
                                  returnHitController.newXPosition.value = details.localPosition.dx;
                                  returnHitController.newYPosition.value = details.localPosition.dy;;
                                }
                              },
                              child: Obx(() {
                                return CustomPaint(
                                  painter: MyCustomPainter(
                                      returnHitController.newXPosition.value, returnHitController.newYPosition.value, ballImage.data, trainingModel),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints.expand(),
                                  ),
                                );
                              }),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  openReturnHitParametersWindow(ReturnHitController controller,
      TrainingModel trainingModel,
      TotalBallController totalBallController) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: controller.editingExistingBall.value == false ? 'Pick hit parameters' : 'Edit hit nr: ${controller.newHit.hitNumber}',
      content: Obx(() {
        return Column(
          children: [
            const SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.rotate_right_outlined, size: 30.0,),
                const SizedBox(width: 5.0,),
                const Text("(forward rotation)", style: TextStyle(fontSize: 12.0)),
                const SizedBox(width: 40.0,),
                CupertinoSwitch(value: controller.newHit.forwardRotation, onChanged: (newValue) {
                  controller.newHit.backwardRotation == false ?
                  controller.newHit.forwardRotation = newValue : null;
                  controller.refreshReturnHit();
                })
              ],
            ),
            const SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.rotate_left_outlined, size: 30.0,),
                const SizedBox(width: 5.0,),
                const Text("(backward rotation)", style: TextStyle(fontSize: 12.0)),
                const SizedBox(width: 40.0,),
                CupertinoSwitch(value: controller.newHit.backwardRotation, onChanged: (newValue) {
                  controller.newHit.forwardRotation == false ?
                  controller.newHit.backwardRotation = newValue : null;
                  controller.refreshReturnHit();
                })
              ],
            ),
            const SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_forward, size: 30.0,),
                const SizedBox(width: 5.0,),
                const Text("(flat ball)", style: TextStyle(fontSize: 12.0)),
                const SizedBox(width: 40.0,),
                CupertinoSwitch(value: controller.newHit.flatBall, onChanged: (newValue) {
                  controller.newHit.topBall == false ?
                  controller.newHit.flatBall = newValue : null;
                  controller.refreshReturnHit();
                })
              ],
            ),
            const SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_upward, size: 30.0,),
                const SizedBox(width: 5.0,),
                const Text("(top ball)", style: TextStyle(fontSize: 12.0),),
                const SizedBox(width: 40.0,),
                CupertinoSwitch(value: controller.newHit.topBall, onChanged: (newValue) {
                  controller.newHit.flatBall == false ?
                  controller.newHit.topBall = newValue : null;
                  controller.refreshReturnHit();
                })
              ],
            ),
            const SizedBox(height: 15.0,),
            const Text("Repeat hit 'x' times: ", style: TextStyle(fontSize: 15.0),),
            const SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      if (controller.newHit.repeatBall > 1) {
                        controller.newHit.repeatBall --;
                        controller.refreshReturnHit();
                      } else {}
                    },
                    child: const Icon(Icons.remove)),
                const SizedBox(width: 6.0,),
                Text(controller.newHit.repeatBall.toString()),
                const SizedBox(width: 6.0,),
                GestureDetector(
                    onTap: () {
                      if (controller.newHit.repeatBall < totalBallController.totalBallValue.value) {
                        controller.newHit.repeatBall ++;
                        controller.refreshReturnHit();
                      } else {}
                    },
                    child: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 15.0,),
            const Text("Time delay (sec): ", style: TextStyle(fontSize: 15.0),),
            const SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      if (controller.newHit.ballDelay > 3) {
                        controller.newHit.ballDelay --;
                        controller.refreshReturnHit();
                      } else {}
                    },
                    child: const Icon(Icons.remove)),
                const SizedBox(width: 6.0,),
                Text(controller.newHit.ballDelay.toString()),
                const SizedBox(width: 6.0,),
                GestureDetector(
                    onTap: () {
                      if (controller.newHit.ballDelay >= 3) {
                        controller.newHit.ballDelay ++;
                        controller.refreshReturnHit();
                      } else {}
                    },
                    child: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(child: const Text('Cancel'), onPressed: () {
                  controller.editingExistingBall.value == false ?
                  controller.hitCounter.value -- : null;
                  controller.editingExistingBall.value = false;
                  Get.back();
                  controller.onInit();
                  controller.hitConfirmed.value == false;
                  // print(controller.newHit.ballPosition);
                }),
                CupertinoButton(child: const Text('Confirm'), onPressed: () {
                  if (controller.editingExistingBall.value == false) {
                    totalBallController.totalBallValue.value -= controller.newHit.repeatBall;
                  } else {
                    if (controller.newHit.repeatBall - controller.editingHitCounter.value > 0) {
                      totalBallController.totalBallValue.value -= (controller.newHit.repeatBall - controller.editingHitCounter.value);
                    } else if (controller.newHit.repeatBall - controller.editingHitCounter.value < 0) {
                      totalBallController.totalBallValue.value += (controller.newHit.repeatBall - controller.editingHitCounter.value).abs();
                    } else {}
                  }
                  controller.editingExistingBall.value == false ?
                  controller.newHit.hitNumber = controller.hitCounter.value : null;
                  controller.editingExistingBall.value = false;
                  ReturnHitModel returnHit = controller.newHit;
                  trainingModel.returnHits.add(returnHit);
                  controller.onInit();
                  Get.back();
                  print(returnHit.toJson());
                  // print(trainingModel.returnHits);
                }),
              ],)
          ],
        );
      }),
    );
  }

}

class MyCustomPainter extends CustomPainter {
  final double newX;
  final double newY;
  final ui.Image myImage;
  final TrainingModel trainingModel;

  MyCustomPainter(
      this.newX,
      this.newY,
      this.myImage,
      this.trainingModel,);


  @override
  void paint(Canvas canvas, Size size) async {
    ReturnHitController returnHitController = Get.find();

    TextPainter _textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );
    for (ReturnHitModel returnHit in trainingModel.returnHits) {
      _textPainter.text = TextSpan(
        text: returnHit.hitNumber.toString(),
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
      );
      _textPainter.layout();
      _textPainter.paint(canvas, Offset(returnHit.ballPositionX + 7.0, returnHit.ballPositionY + 7.0));
      if(returnHitController.positionChangeActivated.value == true && returnHitController.pressedBallNumber.value == returnHit.hitNumber){
        returnHit.ballPositionX = newX;
        returnHit.ballPositionY = newY;
        canvas.drawImage(myImage, Offset(returnHit.ballPositionX - 11, returnHit.ballPositionY - 11), Paint());
      }
      canvas.drawImage(myImage, Offset(returnHit.ballPositionX - 11, returnHit.ballPositionY - 11), Paint());
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) => true;
}


userPressedOnExistingBall(Offset offset, TrainingModel trainingModel) {
  for (ReturnHitModel returnHit in trainingModel.returnHits) {
    if (
    offset.dx >= returnHit.ballPositionX - 15.0 &&
        offset.dx <= returnHit.ballPositionX + 15.0 &&
        offset.dy >= returnHit.ballPositionY - 15.0 &&
        offset.dy <= returnHit.ballPositionY + 15.0
    ) {
      return returnHit;
    }
  }
}


