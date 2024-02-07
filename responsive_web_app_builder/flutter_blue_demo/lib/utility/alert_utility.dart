import 'package:flutter_blue_demo/utility/toast_utility.dart';

// Singleton class for AlertUtility
class AlertUtility {
  // Private constructor to prevent instantiation from outside
  AlertUtility._();

  // Singleton instance
  static final AlertUtility _instance = AlertUtility._();

  // Getter for the singleton instance
  static AlertUtility get instance => _instance;

  // Method to send alert
  void sendAlert({required String alertType}) {
    ToastUtility.showToastAtCenter(alertType);
  }

  void deactivateAlert({required String alertType}) {
    ToastUtility.showToastAtCenter(alertType);
  }
}
