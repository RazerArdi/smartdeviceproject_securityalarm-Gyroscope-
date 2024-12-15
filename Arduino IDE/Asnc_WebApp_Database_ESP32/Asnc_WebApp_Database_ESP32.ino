#include <Wire.h>
#include <WiFi.h>
#include <HTTPClient.h>

// MPU6050 Registers
const int MPU_ADDR = 0x68;  // I2C address of the MPU6050

float accelX, accelY, accelZ;
int16_t rawAccelX, rawAccelY, rawAccelZ;

// Pin assignments
const int LED_PIN = 23;
const int BUZZER_PIN = 19;

// Wi-Fi credentials
const char* ssid = "ArgoMulyo";
const char* password = "hgtkcbtm";

// Server endpoint for sending data
const char* serverName = "http://192.168.18.14/smart_home/insert_data.php";

void setup() {
    Serial.begin(115200);
    
    // Initialize I2C for MPU6050
    Wire.begin();
    Wire.beginTransmission(MPU_ADDR);
    Wire.write(0x6B);  // Power management register
    Wire.write(0);     // Wake up the MPU6050
    Wire.endTransmission(true);
    
    // Initialize pins
    pinMode(LED_PIN, OUTPUT);
    pinMode(BUZZER_PIN, OUTPUT);

    // Connect to Wi-Fi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi!");
}

void loop() {
    // Read accelerometer data
    Wire.beginTransmission(MPU_ADDR);
    Wire.write(0x3B);  // Starting register for accelerometer
    Wire.endTransmission(false);
    Wire.requestFrom(MPU_ADDR, 6, true);

    rawAccelX = Wire.read() << 8 | Wire.read();
    rawAccelY = Wire.read() << 8 | Wire.read();
    rawAccelZ = Wire.read() << 8 | Wire.read();

    // Convert to 'g' forces
    accelX = rawAccelX / 16384.0;
    accelY = rawAccelY / 16384.0;
    accelZ = rawAccelZ / 16384.0;

    // Determine status
    bool isFlat = (abs(accelX) < 0.2 && abs(accelY) < 0.2 && abs(accelZ - 1.0) < 0.2);

    if (isFlat) {
        digitalWrite(LED_PIN, HIGH);
        digitalWrite(BUZZER_PIN, LOW);
        Serial.println("Status: Datar");
    } else {
        digitalWrite(LED_PIN, LOW);
        digitalWrite(BUZZER_PIN, HIGH);
        Serial.println("Status: Miring");
    }

    // Send data to server
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        http.begin(serverName);
        http.addHeader("Content-Type", "application/x-www-form-urlencoded");

        String httpRequestData = "accelX=" + String(accelX) + "&accelY=" + String(accelY) + "&accelZ=" + String(accelZ) + "&isFlat=" + String(isFlat);
        
        // Debugging output for the request data
        Serial.print("Sending data: ");
        Serial.println(httpRequestData);

        int httpResponseCode = http.POST(httpRequestData);

        if (httpResponseCode > 0) {
            Serial.print("Data sent successfully, response code: ");
            Serial.println(httpResponseCode);
        } else {
            Serial.print("Error sending data, response code: ");
            Serial.println(httpResponseCode);
        }
        http.end();
    } else {
        Serial.println("Error in WiFi connection");
    }

    // Print sensor values to Serial Monitor
    Serial.print("AccelX: "); Serial.print(accelX);
    Serial.print(" | AccelY: "); Serial.print(accelY);
    Serial.print(" | AccelZ: "); Serial.println(accelZ);

    delay(500);  // Delay for stability
}
