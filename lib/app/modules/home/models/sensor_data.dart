class SensorData {
  final double accelX;
  final double accelY;
  final double accelZ;
  final bool isFlat;

  SensorData({
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.isFlat,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      // Convert the string values to double using `double.tryParse`
      accelX: double.tryParse(json['accelX'].toString()) ?? 0.0,
      accelY: double.tryParse(json['accelY'].toString()) ?? 0.0,
      accelZ: double.tryParse(json['accelZ'].toString()) ?? 0.0,
      // Convert the string value of `isFlat` to a boolean
      isFlat: json['isFlat'] == 'true', // Ensure it's correctly interpreted as a boolean
    );
  }
}
