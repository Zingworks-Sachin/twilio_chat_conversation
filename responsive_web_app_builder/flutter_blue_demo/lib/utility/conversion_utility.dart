import 'package:flutter/foundation.dart';

class ConversionUtility {
  static int convertBytesToInt16({required List<int> data}) {
    /// Convert Little Endian values to Big Endian
    List<int> reversed = List.from(data.reversed);
    var sensorData = Uint8List.fromList(reversed);
    int val = 0;
    try {
      /// Convert Hex values to int 16 and get angle from 2 bytes
      final val = ByteData.view(sensorData.buffer).getInt16(2, Endian.big);
      return val;
    } catch (e) {
      return val;
    }
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
