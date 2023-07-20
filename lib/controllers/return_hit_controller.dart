import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tennis_training_machine/models/return_hit_model.dart';

class ReturnHitController extends GetxController{

  RxInt pressedBallNumber = 0.obs;
  // RxDouble newXPosition = 100.0.obs;
  // RxDouble newYPosition = 100.0.obs;
  RxBool positionChangeActivated = false.obs;
  RxBool tennisBallDropped = false.obs;
  RxInt hitCounter = 0.obs;
  RxBool hitConfirmed = false.obs;
  RxBool editingExistingBall = false.obs;
  RxInt editingHitCounter = 0.obs;
  final startBallOffset = const Offset(180, 310).obs;

  final _newHit = ReturnHitModel(
      hitNumber: 0,
      ballDelay: 3,
      ballPositionX: 0.0,
      ballPositionY: 0.0,
      repeatBall: 1,
      backwardRotation: false,
      forwardRotation: false,
      flatBall: false,
      topBall: false).obs;
  ReturnHitModel get newHit => _newHit.value;

  @override
  void onInit(){
    super.onInit();
    hitConfirmed.value = false;
    var newHit = ReturnHitModel(
        hitNumber: 0,
        ballDelay: 3,
        ballPositionX: 0.0,
        ballPositionY: 0.0,
        repeatBall: 1,
        backwardRotation: false,
        forwardRotation: false,
        flatBall: false,
        topBall: false);
    _newHit(newHit);
  }

  void refreshReturnHit(){
    _newHit.refresh();
  }

  void setReturnHitController(ReturnHitModel returnHit){
    _newHit(returnHit);
  }
}

