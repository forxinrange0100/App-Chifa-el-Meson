import 'package:flutter/material.dart';

class ScrollControllerProvider extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  ScrollControllerProvider();
  ScrollController get scrollController => _scrollController;

  void scrollToCategory(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final position =
          context.findRenderObject()?.getTransformTo(null).getTranslation();
      if (position != null) {
        final offset = position.y - 80;

        _scrollController.animateTo(offset,
            duration: const Duration(seconds: 1), curve: Curves.ease);
        notifyListeners();
      }
    }
  }
}
