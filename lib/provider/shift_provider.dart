import 'dart:async';

import 'package:chifa_el_meson/utils/fetch_shift.dart';
import 'package:flutter/material.dart';

class ShiftProvider extends ChangeNotifier {
  bool _isOpen = false;
  Timer _timer = Timer(Duration.zero, () {});
  bool get isOpen => _isOpen;
  ShiftProvider() {
    startTimer();
  }

  Future<void> updateIsOpen() async {
    _isOpen = await fetchShift();
    notifyListeners();
  }

  void startTimer() async {
    await updateIsOpen();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      await updateIsOpen();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
