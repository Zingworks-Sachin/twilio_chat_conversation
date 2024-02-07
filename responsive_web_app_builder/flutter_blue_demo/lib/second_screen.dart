import 'package:flutter/material.dart';
import 'package:flutter_blue_demo/background_services.dart';
import 'package:flutter_blue_demo/bluetooth_services.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
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
