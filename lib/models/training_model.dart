// To parse this JSON data, do
//
//     final trainingModel = trainingModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class TrainingModel {
  String name;
  List<dynamic> returnHits;

  TrainingModel({
    required this.name,
    required this.returnHits,
  });

  TrainingModel copyWith({
    String? name,
    List<dynamic>? returnHits,
  }) =>
      TrainingModel(
        name: name ?? this.name,
        returnHits: returnHits ?? this.returnHits,
      );

  factory TrainingModel.fromRawJson(String str) => TrainingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrainingModel.fromJson(Map<String, dynamic> json) => TrainingModel(
    name: json["name"],
    returnHits: List<dynamic>.from(json["returnHits"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "returnHits": List<dynamic>.from(returnHits.map((x) => x)),
  };
}
