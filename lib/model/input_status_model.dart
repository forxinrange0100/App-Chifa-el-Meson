import 'package:chifa_el_meson/enum/input_status_enum.dart';
import 'package:flutter/material.dart';

class InputStatus {
  InputStatusEnum status;
  String errorMessage;
  String Function(String) isValid;

  InputStatus(
      {this.status = InputStatusEnum.empty,
      this.errorMessage = "",
      required this.isValid});

  void verify(String value) {
    if (value.isEmpty) {
      status = InputStatusEnum.empty;
    }
    errorMessage = isValid(value);
    if (errorMessage.isEmpty) {
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
