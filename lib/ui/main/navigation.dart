import 'package:flutter/foundation.dart';

///[ChangeNotifier] for handling the navigation state of the app
class MainNotifier with ChangeNotifier {
  ///initial navigation bar index is the first element which is home
  int _index = 0;
  int _categoryId = 0;
  String _taskContext = '';
  bool _showNotification = false;
  bool _isChange = false;
  bool _isOpenBottomSheet = false;

  ///navigation bar item index
  int get index => _index;

  int get categoryId => _categoryId;

  bool get showNotification => _showNotification;

  String get taskContext => _taskContext;

  bool get isOpen => _isOpenBottomSheet;

  ///change navigation bar item index
  void changeIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void changeCategoryId(int id) {
    _categoryId = categoryId;
    notifyListeners();
  }

  void changeBottomSheet(bool b) {
    _isOpenBottomSheet = b;
    notifyListeners();
  }

  void changeTaskContent(String text) {
    _taskContext = taskContext;
    notifyListeners();
  }

  void changeNotification(bool b) {
    if (b && !_isChange) {
      _isChange = b;
      _showNotification = b;
      notifyListeners();
    }
    else if(_showNotification && _isChange){
      _showNotification = b;
      notifyListeners();
    }
  }
}
