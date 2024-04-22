part of '../overlay_popup.dart';

class OverlayPopupController extends ChangeNotifier {
  bool showing = false;

  void showMenu() {
    showing = true;
    notifyListeners();
  }

  void hideMenu() {
    showing = false;
    notifyListeners();
  }

  void toggleMenu() {
    showing = !showing;
    notifyListeners();
  }
}
