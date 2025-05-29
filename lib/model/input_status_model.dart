import 'package:delivera/enum/input_status_enum.dart';
import 'package:flutter/material.dart';

class InputStatus {
  InputStatusEnum status;
  final String errorMessage;
  bool Function(String) isValid;

  InputStatus(
      {this.status = InputStatusEnum.empty,
      required this.isValid,
      required this.errorMessage});

  void verify(String value) {
    if (value.isEmpty) {
      status = InputStatusEnum.empty;
      return;
    }
    if (isValid(value)) {
      status = InputStatusEnum.valid;
    } else {
      status = InputStatusEnum.invalid;
    }
  }

  Color getStatusColor() {
    if (status == InputStatusEnum.empty) {
      return Colors.grey;
    } else if (status == InputStatusEnum.valid) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
