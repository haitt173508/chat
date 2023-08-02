// To parse this JSON data, do
//
//     final resultListShiftModel = resultListShiftModelFromJson(jsonString);

import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ResultListShiftModel resultListShiftModelFromJson(String str) => ResultListShiftModel.fromJson(json.decode(str));

String resultListShiftModelToJson(ResultListShiftModel data) => json.encode(data.toJson());

class ResultListShiftModel {
  ResultListShiftModel({
    required this.data,
    required this.error,
  });

  final GetListShift? data;
  final ErrorResponse? error;

  factory ResultListShiftModel.fromJson(Map<String, dynamic> json) => ResultListShiftModel(
        data: json["data"] == null ? null : GetListShift.fromJson(json["data"]),
        error: json["error"] == null ? null : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error": error,
      };
}

class GetListShift {
  GetListShift({
    required this.epName,
    required this.shift,
  });

  final String epName;
  final List<Shift> shift;

  factory GetListShift.fromJson(Map<String, dynamic> json) => GetListShift(
        epName: json["ep_name"] ?? "",
        shift: json["shift"] == null ? [] : List<Shift>.from(json["shift"].map((x) => Shift.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ep_name": epName,
        "shift": List<dynamic>.from(shift.map((x) => x.toJson())),
      };
}

class Shift {
  Shift({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
  });

  final String shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        shiftId: json["shift_id"] ?? "",
        shiftName: json["shift_name"] ?? "",
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "shift_id": shiftId,
        "shift_name": shiftName,
        "start_time": startTime,
        "end_time": endTime,
      };
}
