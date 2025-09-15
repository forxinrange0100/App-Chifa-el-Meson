import 'dart:async';

import 'package:delivera/utils/fetch_shift.dart';
import 'package:delivera/utils/fetch_shift_is_paused.dart';
import 'package:flutter/material.dart';

/// A provider that manages the shift status (open/closed) and updates it periodically.
class ShiftProvider extends ChangeNotifier {
  bool _isOpen = false;
  Timer _timer = Timer(Duration.zero, () {});

  bool get isOpen => _isOpen;
  
  ShiftProvider() {
    startTimer();
  }

  /// Updates the [_isOpen] variable by fetching the current shift status.
  /// This method checks if there is a shift opened and not paused, then notifies listeners.
  Future<void> updateIsOpen() async {
    _isOpen = await fetchShift() && !await fetchShiftIsPaused();
    notifyListeners();
  }

  /// Starts a timer that updates the shift status every minute.
  /// It also performs an initial update when called.
  /// This method should be called once when the provider is initialized.
  /// It updates the [_isOpen] variable and notifies listeners.
  void startTimer() async {
    await updateIsOpen();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      await updateIsOpen();
    });
  }

  /// Cancels the timer when the provider is disposed.
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
