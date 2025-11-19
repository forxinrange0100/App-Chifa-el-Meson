import 'dart:async';
import 'dart:developer' show log;

import 'package:delivera/toast/toast.dart' show serverErrorToast;
import 'package:delivera/utils/fetch_shift.dart';
import 'package:delivera/utils/fetch_shift_is_paused.dart';
import 'package:flutter/material.dart';

/// A provider that manages the shift status (open/closed) and updates it periodically.
class ShiftProvider extends ChangeNotifier {
  bool _isOpen = false;
  Timer _timer = Timer(Duration.zero, () {});
  bool _isFetching = false;

  bool get isOpen => _isOpen;
  bool get isFetching => _isFetching;

  ShiftProvider() {
    startTimer();
  }

  /// Cambia el valor de [_isFetching] y notifica a los listeners.
  void _setIsFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  /// Updates the [_isOpen] variable by fetching the current shift status.
  /// This method checks if there is a shift opened and not paused, then notifies listeners.
  Future<bool> updateIsOpen([bool shouldToggleIsFetching = true]) async {
    if (shouldToggleIsFetching) _setIsFetching(true);

    bool success = false;
    try {
      _isOpen = await fetchShift() && !await fetchShiftIsPaused();
      success = true;
    } catch (e, s) {
      _isOpen = false;
      log("Error al verificar el estado del turno: $e", stackTrace: s);
    }

    if (!shouldToggleIsFetching) {
      notifyListeners();
      return success;
    }

    _setIsFetching(false);
    if (!success) {
      serverErrorToast("Error al verificar el estado del turno. Por favor, intente más tarde.");
    }

    return success;
  }

  /// Starts a timer that updates the shift status every minute.
  /// It also performs an initial update when called.
  /// This method should be called once when the provider is initialized.
  /// It updates the [_isOpen] variable and notifies listeners.
  void startTimer() async {
    await updateIsOpen(false);
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      await updateIsOpen(false);
    });
  }

  /// Cancels the timer when the provider is disposed.
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
