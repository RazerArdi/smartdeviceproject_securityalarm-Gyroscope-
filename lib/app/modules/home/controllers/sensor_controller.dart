import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/sensor_data.dart';

class SensorController extends GetxController {
  var sensorData = SensorData(accelX: 0, accelY: 0, accelZ: 0, isFlat: false).obs;

  @override
  void onInit() {
    super.onInit();
    // Start periodic fetching of sensor data
    Timer.periodic(Duration(seconds: 2), (timer) {
      fetchSensorData();
    });
  }

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.18.14/smart_home/sensor_data.php'));

      if (response.statusCode == 200) {
        // Assuming the response body is a string, you need to decode it into a Map
        var decodedResponse = json.decode(response.body);  // This returns a Map<String, dynamic>

        // Now, you can pass the decoded data to the SensorData model
        sensorData.value = SensorData.fromJson(decodedResponse);
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
