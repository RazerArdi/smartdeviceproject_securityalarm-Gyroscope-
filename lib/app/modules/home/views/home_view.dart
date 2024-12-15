import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/sensor_controller.dart';

class HomeView extends StatelessWidget {
  final SensorController sensorController = Get.put(SensorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Smart Home Sensor",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          final sensor = sensorController.sensorData.value;
          return Container(
            width: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSensorInfoTile(
                  icon: Icons.speed,
                  label: "Acceleration X",
                  value: sensor.accelX.toStringAsFixed(2),
                ),
                SizedBox(height: 12),
                _buildSensorInfoTile(
                  icon: Icons.speed,
                  label: "Acceleration Y",
                  value: sensor.accelY.toStringAsFixed(2),
                ),
                SizedBox(height: 12),
                _buildSensorInfoTile(
                  icon: Icons.speed,
                  label: "Acceleration Z",
                  value: sensor.accelZ.toStringAsFixed(2),
                ),
                SizedBox(height: 12),
                _buildStatusChip(sensor.isFlat),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: sensorController.fetchSensorData,
        icon: Icon(Icons.refresh, color: Colors.white),
        label: Text(
          "Update Sensors",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  Widget _buildSensorInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(bool isFlat) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isFlat ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFlat ? Icons.check_circle : Icons.warning,
            color: isFlat ? Colors.green : Colors.red,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            isFlat ? 'Flat' : 'Tilted',
            style: GoogleFonts.roboto(
              color: isFlat ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}