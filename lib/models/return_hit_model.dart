// To parse this JSON data, do
//
//     final returnHitModel = returnHitModelFromJson(jsonString);

import 'dart:ui';
import 'dart:convert';

class ReturnHitModel {
  int ballDelay;
  int hitNumber;
  double ballPositionX;
  double ballPositionY;
  int repeatBall;
  bool backwardRotation;
  bool forwardRotation;
  bool flatBall;
  bool topBall;

  ReturnHitModel({
    required this.ballDelay,
    required this.hitNumber,
    required this.ballPositionX,
    required this.ballPositionY,
    required this.repeatBall,
    required this.backwardRotation,
    required this.forwardRotation,
    required this.flatBall,
    required this.topBall,
  });

  ReturnHitModel copyWith({
    int? ballDelay,
    int? hitNumber,
    double? ballPositionX,
    double? ballPositionY,
    int? repeatBall,
    bool? backwardRotation,
    bool? forwardRotation,
    bool? flatBall,
    bool? topBall,
  }) =>
      ReturnHitModel(
        ballDelay: ballDelay ?? this.ballDelay,
        hitNumber: hitNumber ?? this.hitNumber,
        ballPositionX: ballPositionX ?? this.ballPositionX,
        ballPositionY: ballPositionY ?? this.ballPositionY,
        repeatBall: repeatBall ?? this.repeatBall,
        backwardRotation: backwardRotation ?? this.backwardRotation,
        forwardRotation: forwardRotation ?? this.forwardRotation,
        flatBall: flatBall ?? this.flatBall,
        topBall: topBall ?? this.topBall,
      );

  factory ReturnHitModel.fromRawJson(String str) => ReturnHitModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReturnHitModel.fromJson(Map<String, dynamic> json) => ReturnHitModel(
    ballDelay: json["ballDelay"],
    hitNumber: json["hitNumber"],
    ballPositionX: json["ballPositionX"],
    ballPositionY: json["ballPositionY"],
    repeatBall: json["repeatBall"],
    backwardRotation: json["backwardRotation"],
    forwardRotation: json["forwardRotation"],
    flatBall: json["flatBall"],
    topBall: json["topBall"],
  );

  Map<String, dynamic> toJson() => {
    "ballDelay": ballDelay,
    "hitNumber": hitNumber,
    "ballPositionX": ballPositionX,
    "ballPositionY": ballPositionY,
    "repeatBall": repeatBall,
    "backwardRotation": backwardRotation,
    "forwardRotation": forwardRotation,
    "flatBall": flatBall,
    "topBall": topBall,
  };
}
