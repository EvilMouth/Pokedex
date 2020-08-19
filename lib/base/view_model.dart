import 'package:flutter/material.dart';

class BaseViewModelWithLoadingState with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  markLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
