import 'package:flutter/material.dart';
import 'package:flutter_blue_demo/background_services.dart';
import 'package:flutter_blue_demo/bluetooth_services.dart';
import 'package:flutter_blue_demo/toast_utility.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BackgroundServicesUtility backgroundServicesUtility =
      BackgroundServicesUtility.instance;
  final BluetoothServices bluetoothService = BluetoothServices.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBackgroundService();
  }

  checkBackgroundService() async {
    bool isBackgroundServiceRunning =
        await backgroundServicesUtility.isBackgroundServiceRunning;
    if (isBackgroundServiceRunning) {
      backgroundServicesUtility.service.invoke("startBleOperation");
    } else {
      backgroundServicesUtility.startBackgroundService(serviceType: "On");
    }
    listenToBackgroundServices();
  }

  listenToBackgroundServices() {
    backgroundServicesUtility.service
        .on("bluetoothDeviceState")
        .listen((connectionStatus) {
      debugPrint(
          'Value from connectionStatus on 2nd screen: $connectionStatus');
      ToastUtility.showToastAtCenter("Amicane is connected");

      switch (connectionStatus?["BluetoothConnectionState"]) {
        case "disconnected":
          backgroundServicesUtility.bluetoothConnectionState =
              BluetoothConnectionState.disconnected;
          break;
        case "connecting":
          backgroundServicesUtility.bluetoothConnectionState =
              BluetoothConnectionState.connecting;
          break;
        case "connected":
          backgroundServicesUtility.bluetoothConnectionState =
              BluetoothConnectionState.connected;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Screen"),
      ),
      body: const Center(child: Text("")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This tra
    );
  }
}
