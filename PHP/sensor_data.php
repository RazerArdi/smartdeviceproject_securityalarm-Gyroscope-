<?php
// Allow requests from any origin
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Your database connection and query code
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "smart_home";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch the latest sensor data
$sql = "SELECT * FROM sensor_data ORDER BY timestamp DESC LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode([
        'accelX' => $row['accelX'],
        'accelY' => $row['accelY'],
        'accelZ' => $row['accelZ'],
        'isFlat' => $row['isFlat'] ? 'true' : 'false'
    ]);
} else {
    echo json_encode(['error' => 'No data found']);
}

$conn->close();
?>
