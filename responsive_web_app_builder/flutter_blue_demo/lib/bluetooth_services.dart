import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothServices {
  // Private constructor
  BluetoothServices._privateConstructor();

  // Static instance of the singleton class
  static final BluetoothServices _instance =
      BluetoothServices._privateConstructor();

  // Getter to access the singleton instance
  static BluetoothServices get instance => _instance;

  Future<void> startScan({
    List<Guid> withServices = const [],
    Duration? timeout,
    List<String> withRemoteIds = const [],
    Duration? removeIfGone,
    bool oneByOne = false,
    bool androidUsesFineLocation = false,
  }) {
    return FlutterBluePlus.startScan(
      withServices: withServices,
      timeout: timeout,
      removeIfGone: removeIfGone,
      oneByOne: oneByOne,
      withRemoteIds: withRemoteIds,
      androidUsesFineLocation: androidUsesFineLocation,
    );
  }

  Stream<BluetoothAdapterState> get adapterState {
    return FlutterBluePlus.adapterState;
  }

  Stream<List<ScanResult>> get onScanResults {
    return FlutterBluePlus.onScanResults;
  }

  Stream<List<ScanResult>> get scanResults {
    return FlutterBluePlus.scanResults;
  }

  bool get isScanningNow {
    return FlutterBluePlus.isScanningNow;
  }

  Stream<bool> get isScanning {
    return FlutterBluePlus.isScanning;
  }

  Future<void> stopScan() {
    return FlutterBluePlus.stopScan();
  }

  void setLogLevel(LogLevel level, {color = true}) {
    return FlutterBluePlus.setLogLevel(level, color: color);
  }

  LogLevel get logLevel {
    return FlutterBluePlus.logLevel;
  }

  Future<bool> get isSupported {
    return FlutterBluePlus.isSupported;
  }

  Future<String> get adapterName {
    return FlutterBluePlus.adapterName;
  }

  BluetoothAdapterState get adapterStateNow {
    return FlutterBluePlus.adapterStateNow;
  }

  Future<void> turnOn({int timeout = 60}) {
    return FlutterBluePlus.turnOn(timeout: timeout);
  }

  List<BluetoothDevice> get connectedDevices {
    return FlutterBluePlus.connectedDevices;
  }

  Future<List<BluetoothDevice>> get systemDevices {
    return FlutterBluePlus.systemDevices;
  }

  Future<PhySupport> getPhySupport() {
    return FlutterBluePlus.getPhySupport();
  }

  Future<List<BluetoothDevice>> get bondedDevices {
    return FlutterBluePlus.bondedDevices;
  }

  BluetoothConnectionState bleConnectionState =
      BluetoothConnectionState.disconnected;

  BluetoothConnectionState get bluetoothConnectionState {
    print("ble_utility_get->$bleConnectionState");
    return bleConnectionState;
  }

  set bluetoothConnectionState(
      BluetoothConnectionState bluetoothConnectionState) {
    print("ble_utility_set->$bluetoothConnectionState");
    bleConnectionState = bluetoothConnectionState;
  }

  BluetoothDevice? bleDevice;

  BluetoothDevice? get bluetoothDevice {
    return bleDevice;
  }

  set bluetoothDevice(BluetoothDevice? bluetoothDevice) {
    bleDevice = bluetoothDevice;
  }

  bool get isBluetoothDeviceConnected {
    return bluetoothDevice?.isConnected ?? false;
  }

  Future<List<BluetoothCharacteristic>> getCharacteristicsList(
      List<BluetoothService> servicesList, Guid serviceUuid) async {
    return servicesList
        .where((service) => service.uuid.str == serviceUuid.str)
        .expand((services) => services.characteristics)
        .toList();
  }
}
