import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_blue_demo/bluetooth_activity.dart';
import 'package:flutter_blue_demo/bluetooth_services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundServicesUtility {
  // Private constructor
  BackgroundServicesUtility._privateConstructor();

  // Static instance of the singleton class
  static final BackgroundServicesUtility _instance =
      BackgroundServicesUtility._privateConstructor();

  // Getter to access the singleton instance
  static BackgroundServicesUtility get instance => _instance;

  final service = FlutterBackgroundService();
  static Timer? geofenceTimer;
  static ServiceInstance? serviceInstance;
  BluetoothServices flutterBluePlusUtility = BluetoothServices.instance;
  BluetoothActivity bluetoothActivity = BluetoothActivity.instance;
  Future<bool> get isBackgroundServiceRunning {
    return service.isRunning();
  }

  BluetoothConnectionState get bluetoothConnectionState {
    return flutterBluePlusUtility.bluetoothConnectionState;
  }

  set bluetoothConnectionState(
      BluetoothConnectionState bluetoothConnectionState) {
    flutterBluePlusUtility.bluetoothConnectionState = bluetoothConnectionState;
  }

  BluetoothAdapterState get bluetoothAdapterState {
    return flutterBluePlusUtility.adapterStateNow;
  }

  Future startBackgroundService({required String serviceType}) async {
    debugPrint("startBackgroundService called");
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStartBackgroundService,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will be executed when app is in foreground in separated isolate
        onForeground: onStartBackgroundService,

        // you have to enable background fetch capability on xcode project
        onBackground: onStartIosBackgroundService,
      ),
    );
    // service.startService();
    if (serviceType == "On") {
      service.startService();
    } else {
      service.invoke("stopService");
    }
  }

  @pragma('vm:entry-point')
  static onStartBackgroundService(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    debugPrint("onStartBackgroundService called");
    startBackgroundServiceForAndroidAndIOS(service: service);
  }

  @pragma('vm:entry-point')
  static Future<bool> onStartIosBackgroundService(
      ServiceInstance service) async {
    await startBackgroundServiceForAndroidAndIOS(service: service);
    return true;
  }

  static startGeofenceAndLocationServices() async {
    // Map amiCaneUserDetails = await HiveUtility.getAmiCaneUserDetails();
    // if (amiCaneUserDetails.isNotEmpty) {
    //   debugPrint("amiCaneUserDetails in killed state ->$amiCaneUserDetails");
    //   UpdatedUserData userData = UpdatedUserData?.fromJson(amiCaneUserDetails);
    //   setAmicaneCurrentLocationInBg(userDetails: userData);
    //   createGeoFenceInBg(userData: userData);
    // }
  }

  static listenToBluetoothAdapterState() async {
    instance.flutterBluePlusUtility.adapterState.listen((event) {
      switch (event) {
        case BluetoothAdapterState.unknown:
          debugPrint("BluetoothAdapterState unknown");

          // TODO: Handle this case.
          // if (Platform.isIOS) {
          //   if (bluetoothState == BluetoothAdapterState.off ||
          //       bluetoothState == null) {
          //     startBleOperations("", true, false);
          //     debugPrint(
          //         "background service page listenToBluetoothAdapterState method ");
          //     bluetoothState = BluetoothAdapterState.on;
          //   }
          // }
          break;
        case BluetoothAdapterState.unavailable:
          debugPrint("BluetoothAdapterState unavailable");

          // TODO: Handle this case.
          break;
        case BluetoothAdapterState.unauthorized:
          debugPrint("BluetoothAdapterState unauthorized");

          // TODO: Handle this case.
          break;
        case BluetoothAdapterState.turningOn:
          debugPrint("BluetoothAdapterState turningOn");

          break;
        case BluetoothAdapterState.on:
          debugPrint("BluetoothAdapterState on");
          instance.startBleOperations(
              macId: "48:23:35:00:86:D9",
              shouldDiscoverService: true,
              enableShippingMode: false);
          break;
        case BluetoothAdapterState.turningOff:
          debugPrint("BluetoothAdapterState turningOff");
          break;
        case BluetoothAdapterState.off:
          debugPrint("BluetoothAdapterState off");

          instance.service.invoke("bluetoothState", {"bluetoothState": "off"});
          instance.service.invoke(
              "bluetoothDeviceState", {"BluetoothDeviceState": "disconnected"});
          // androidServiceInstanceService!.invoke(
          //     "bluetoothDeviceState", {"BluetoothDeviceState": "disconnected"});
          break;
      }
    });
    if (instance.flutterBluePlusUtility.adapterStateNow ==
        BluetoothAdapterState.on) {
      instance.startBleOperations(
          macId: "48:23:35:00:86:D9",
          shouldDiscoverService: true,
          enableShippingMode: false);
    } else {
      instance.service.invoke("bluetoothState", {"bluetoothState": "off"});
    }
  }

  startBleOperations(
      {required String macId,
      required bool shouldDiscoverService,
      required bool enableShippingMode}) async {
    debugPrint("macId:- $macId");
    bluetoothActivity.startBleOperations(
        macId: macId,
        shouldDiscoverService: shouldDiscoverService,
        enableShippingMode: enableShippingMode);
  }

  void sendDataFromBackgroundServiceToUI(String method,
      [Map<String, dynamic>? args]) {
    serviceInstance?.invoke(method, args);
  }

  void sendDataFromUIToBackgroundService(String method,
      [Map<String, dynamic>? args]) {
    serviceInstance?.invoke(method, args);
  }

  listenToEventsFromUI(ServiceInstance service) {
    if (service is AndroidServiceInstance) {
      debugPrint("service is AndroidServiceInstance called");
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
        debugPrint("setAsForeground called");
        service.invoke(
          'update',
          {
            "current_date": DateTime.now().toIso8601String(),
            "device": "setAsForeground",
          },
        );
      });
    }

    service.on("startBleOperation").listen((event) {
      print("startBleOperation called");
      startBleOperations(
          macId: "48:23:35:00:86:D9",
          shouldDiscoverService: true,
          enableShippingMode: true);
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
      debugPrint("stopService called");
    });
    // service.on('startBle').listen((event) async {
    //   debugPrint("startBle called");
    //   bool isBluetoothOn = instance.flutterBluePlusUtility.adapterStateNow ==
    //       BluetoothAdapterState.on;
    //   debugPrint("isBluetoothOn->$isBluetoothOn");
    //   if (isBluetoothOn) {
    //     await instance.startBleOperations("", true, false);
    //     debugPrint(
    //         "background services page startBackgroundServiceForAndroidAndIOS method ");
    //   } else {
    //     serviceInstance?.invoke("bluetoothState", {"bluetoothState": "off"});
    //   }
    // });
    service.on('denyButtonClick').listen((event) {
      debugPrint("denyButtonClick called");
    });
    service.on('disconnectDevice').listen((event) {
      debugPrint("disconnectDevice called");
      // FlutterBlueUtilityBackground.reInitializeBle();
      // FlutterBlueUtilityBackground.stopScan();
      serviceInstance?.invoke(
          "bluetoothDeviceState", {"BluetoothDeviceState": "disconnected"});
    });
  }

  static startBackgroundServiceForAndroidAndIOS(
      {required ServiceInstance service}) async {
    debugPrint("startBackgroundServiceForAndroidAndIOS called");
    instance.listenToEventsFromUI(service);
    DartPluginRegistrant.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    serviceInstance = service;
    listenToBluetoothAdapterState();
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          /// OPTIONAL for use custom notification
          /// the notification id must be equals with AndroidConfiguration when you call configure() method.

          final FlutterLocalNotificationsPlugin
              flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          flutterLocalNotificationsPlugin.show(
            888,
            'AmiCane service is running...',
            "Tap to open the app",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'my_foreground', 'MY FOREGROUND SERVICE',
                  icon: '@mipmap/ic_launcher',
                  ongoing: true,
                  enableVibration: false,
                  playSound: false,
                  sound: null,
                  onlyAlertOnce: true),
              // iOS: IOSNotificationDetails(
              //     sound: null, subtitle: "AmiCane service is running...")
            ),
          );
        }
      }
    });
    startGeofenceAndLocationServices();
  }
}
