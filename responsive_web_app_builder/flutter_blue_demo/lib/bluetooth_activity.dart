import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_demo/alert_utility.dart';
import 'package:flutter_blue_demo/background_services.dart';
import 'package:flutter_blue_demo/bluetooth_services.dart';
import 'package:flutter_blue_demo/conversion_utility.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothActivity {
  // Private constructor
  BluetoothActivity._privateConstructor();

  // Static instance of the singleton class
  static final BluetoothActivity _instance =
      BluetoothActivity._privateConstructor();
  static BluetoothActivity get instance => _instance;

  /// These are the UUIDs of your device
  static final Guid serviceUuid = Guid("ffb6e603-11f0-4cff-9b0c-48589907ff33");
  static final Guid caneAngleCharacteristic =
      Guid("74212b37-34fb-46e7-9d62-b5adce5d8c72");
  static final Guid caneStateCharacteristic =
      Guid("942e997e-4ba3-472b-88e0-e1cfea42c29a");
  static final Guid batteryStateCharacteristic =
      Guid("742e9812-4ba3-472b-88e0-e1cfea42c2ae");
  static BluetoothServices bluetoothServices = BluetoothServices.instance;
  static BackgroundServicesUtility backgroundServicesUtility =
      BackgroundServicesUtility.instance;
  static int thresholdAngle = 45;
  static int thresholdAngle1 = 90 - thresholdAngle;
  static int thresholdAngle2 = 90 + thresholdAngle;
  static int verticalCount = 0;
  static int thresholdCount = 0;
  static int notVerticalCount = 0;
  static int earlierPosition = -1;
  static int currentPosition = -1;
  static const int caneStateNotVerticalValue = 0x04;
  static const int angleUpdateInterval = 500;
  static const int caneStateReset = 0x00;
  static const int caneStateResetToStopBeep = 0x81;
  static const int caneStateLocateMe = 0x08;
  static const int caneStateLocateMeFound = 0x80;
  static const int vertical = 1;
  static const int notVertical = 0;

  static int caneDataDelay = 6;
  static int caneAlertThresholdValue = 10;
  static bool isDeviceConnected = false;
  static bool isDeviceConnectedInForeground = false;

  static bool caneDropFlag = true;
  static DateTime lastDisconnectedAlertDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static DateTime lastConnectedAlertDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static bool stickConnectionFlag = true;
  static bool connectionFlag = true;
  static String lastCalledNumber = "";
  static int alertCallTime = DateTime.now().millisecondsSinceEpoch;
  static int lastBitValueFromStick = 0;
  static BluetoothCharacteristic? stateCharacteristic;
  static BluetoothCharacteristic? batteryCharacteristic;
  static const int toEnterInShippingMode = 0xD1;
  static const int toExitShippingMode = 0xD0;
  static BluetoothCharacteristic? angleCharacteristic;
  static BluetoothDevice? amicaneDevice;
  static Timer? rssiTimer;
  static Timer? batteryTimer;

  BluetoothConnectionState get bluetoothConnectionState {
    return bluetoothServices.bluetoothConnectionState;
  }

  set bluetoothConnectionState(
      BluetoothConnectionState bluetoothConnectionState) {
    bluetoothServices.bluetoothConnectionState = bluetoothConnectionState;
  }

  BluetoothDevice? get bluetoothDevice {
    return bluetoothServices.bluetoothDevice;
  }

  set bluetoothDevice(BluetoothDevice? bluetoothDevice) {
    bluetoothServices.bluetoothDevice = bluetoothDevice;
  }

  // Method for starting a Bluetooth scan
  void startBleOperations({
    required String macId,
    required bool shouldDiscoverService,
    required bool enableShippingMode,
  }) async {
    BluetoothDevice? bluetoothDevice =
        await getDeviceFromConnectedDevicesList(macId: macId);
    print("flutterBlue.connectedDevice->$bluetoothDevice");
    print("flutterBlue.connectedDevice->${bluetoothDevice?.isConnected}");
    if (bluetoothDevice?.isConnected == true) {
      print("flutterBlue.connectedDevice->${bluetoothDevice?.servicesList}");

      discoverServices(bluetoothDevice: bluetoothDevice!);
    } else {
      startScan(
          macId: macId,
          shouldDiscoverService: shouldDiscoverService,
          enableShippingMode: enableShippingMode);
    }
  }

  // Method for starting a Bluetooth scan
  void startScan({
    required String macId,
    required bool shouldDiscoverService,
    required bool enableShippingMode,
  }) {
    bluetoothServices.onScanResults.listen((listOfDevices) {
      print("listOfDevices->$listOfDevices");
      for (var result in listOfDevices) {
        print(
            "result.device.remoteId.str->${result.device.remoteId.str}--name->${result.device.platformName}");
        if (result.device.remoteId.str == macId) {
          connectToDevice(
              macId: macId,
              bleDevice: result.device,
              enableShippingMode: enableShippingMode);
        }
      }
    });
    // FlutterBluePlus.cancelWhenScanComplete(subscription);
    bluetoothServices.startScan(withRemoteIds: [macId]);
  }

  void connectToDevice({
    required String macId,
    required BluetoothDevice bleDevice,
    required bool enableShippingMode,
  }) async {
    bleDevice.connectionState.listen((connectionState) {
      if (bluetoothConnectionState != connectionState) {
        bluetoothConnectionState = connectionState;
        if (bluetoothConnectionState == BluetoothConnectionState.connected) {
          backgroundServicesUtility.sendDataFromBackgroundServiceToUI(
              "bluetoothDeviceState", {"BluetoothDeviceState": "connected"});
          bluetoothDevice = bleDevice;
          discoverServices(bluetoothDevice: bleDevice);
        } else {
          bluetoothDevice = null;
          backgroundServicesUtility.sendDataFromBackgroundServiceToUI(
              "bluetoothDeviceState", {"BluetoothDeviceState": "disconnected"});
        }
      }
    });
    await bleDevice.connect().onError((error, stackTrace) {});
  }

  void discoverServices({required BluetoothDevice bluetoothDevice}) async {
    List<BluetoothService> servicesList =
        await bluetoothDevice.discoverServices();
    List<BluetoothCharacteristic> bluetoothCharacteristicList =
        await bluetoothServices.getCharacteristicsList(
            servicesList, serviceUuid);
    subscribeToCharacteristicsAndEvents(
        bluetoothCharacteristicList: bluetoothCharacteristicList);
  }

  subscribeToCharacteristicsAndEvents(
      {required List<BluetoothCharacteristic> bluetoothCharacteristicList}) {
    try {
      BluetoothCharacteristic stateCharacteristic =
          bluetoothCharacteristicList.firstWhere((characteristic) =>
              characteristic.uuid == caneStateCharacteristic);
      BluetoothCharacteristic angleCharacteristic =
          bluetoothCharacteristicList.firstWhere((characteristic) =>
              characteristic.uuid == caneAngleCharacteristic);

      stateCharacteristic.onValueReceived.listen((data) {
        if (data.isNotEmpty) {
          if (data.contains(3)) {
            AlertUtility.instance.sendAlert(alertType: "SOS Activated");
          }
          if (data.contains(2)) {
            AlertUtility.instance.sendAlert(alertType: "SOS Deactivated");
          }
        }
      });
      angleCharacteristic.onValueReceived.listen((data) async {
        int angle = ConversionUtility.convertBytesToInt16(data: data);
        debugPrint("angle->$angle");
        await updateCaneDataOnAngleChange(angle: angle);
      });

      stateCharacteristic.setNotifyValue(true);
      angleCharacteristic.setNotifyValue(true);
    } catch (e) {
      debugPrint("subscribeToCharacteristicsAndEvents error->$e");
    }
  }

  static updateCaneDataOnAngleChange({required int angle}) async {
    if (angle < 0) angle = angle + 360;
    if (angle >= 0 && angle <= 360) {
      thresholdAngle1 = 90 - thresholdAngle;
      thresholdAngle2 = 90 + thresholdAngle;
      thresholdCount = (caneDataDelay * 1000) ~/ angleUpdateInterval;
      if (angle >= thresholdAngle1 && angle <= thresholdAngle2) {
        notVerticalCount = 0;
        verticalCount++;
        if (verticalCount > thresholdCount) {
          verticalCount = 0;
          currentPosition = vertical;
          if (earlierPosition == notVertical) {
            if (kDebugMode) print("Cane orientation changed!...");
            if (!caneDropFlag) {
              caneDropFlag = true;
              // deactivateAlertOnCaneVertical(
              //   userData: userData,
              // );
              AlertUtility.instance
                  .sendAlert(alertType: "Cane drop alert deactivated");
            }
          }
          earlierPosition = vertical;
        }
      } else {
        verticalCount = 0;
        notVerticalCount++;

        ///Generate alert after set threshold duration
        Future.delayed(Duration(seconds: caneAlertThresholdValue), () {
          if (notVerticalCount > thresholdCount) {
            notVerticalCount = 0;
            currentPosition = notVertical;
            if (earlierPosition == vertical || earlierPosition == -1) {
              if (kDebugMode) print("Cane orientation changed!...");
              AlertUtility.instance.sendAlert(alertType: "Cane drop alert");
            }
            earlierPosition = notVertical;
          }
        });
      }
    }
  }

  Future<BluetoothDevice?> getDeviceFromConnectedDevicesList(
      {required String macId}) async {
    List<BluetoothDevice?> listOfConnectedDevice = [];
    BluetoothDevice? connectedDevice;
    listOfConnectedDevice =
        backgroundServicesUtility.flutterBluePlusUtility.connectedDevices;
    if (listOfConnectedDevice.isNotEmpty) {
      String stickName =
          "SStick-${macId.replaceAll(":", "").lastChars(4).toLowerCase()}";
      connectedDevice = listOfConnectedDevice.firstWhere((device) =>
          (device!.remoteId.str == macId || device.remoteId.str == stickName));
    }
    return connectedDevice;
  }
}
