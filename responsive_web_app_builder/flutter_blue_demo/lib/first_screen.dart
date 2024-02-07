import 'package:flutter/material.dart';
import 'package:flutter_blue_demo/background_services.dart';
import 'package:flutter_blue_demo/second_screen.dart';
import 'package:flutter_blue_demo/toast_utility.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final BackgroundServicesUtility backgroundServicesUtility =
      BackgroundServicesUtility.instance;
  final BluetoothConnectionState connectedDeviceState =
      BluetoothConnectionState.disconnected;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  listenToBackgroundServices() {
    print(
        "backgroundServicesUtility.service.=>${backgroundServicesUtility.service.hashCode}");
    backgroundServicesUtility.service
        .on("bluetoothDeviceState")
        .listen((connectionStatus) {
      debugPrint('Value from connectionStatus: $connectionStatus');
      switch (connectionStatus?["BluetoothConnectionState"]) {
        case "disconnected":
          backgroundServicesUtility.bluetoothConnectionState =
              BluetoothConnectionState.disconnected;
          ToastUtility.showToastAtCenter("Amicane is disconnected");
          break;
        case "connecting":
          backgroundServicesUtility.bluetoothConnectionState =
              BluetoothConnectionState.connecting;
          break;
        case "connected":
          backgroundServicesUtility.bluetoothConnectionState =
              BluetoothConnectionState.connected;
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          });
          break;
      }
    });
  }

  initData() {
    listenToBackgroundServices();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trying To Connect Screen"),
      ),
      body: const Center(child: Text("")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This tra
    );
  }
}
