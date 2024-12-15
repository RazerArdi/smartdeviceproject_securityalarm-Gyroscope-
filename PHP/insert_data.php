<?php
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

// Validate and sanitize inputs
$accelX = isset($_POST['accelX']) ? (float)$_POST['accelX'] : null;
$accelY = isset($_POST['accelY']) ? (float)$_POST['accelY'] : null;
$accelZ = isset($_POST['accelZ']) ? (float)$_POST['accelZ'] : null;
$isFlat = isset($_POST['isFlat']) ? $conn->real_escape_string($_POST['isFlat']) : null;

// Check if all required inputs are provided
if ($accelX !== null && $accelY !== null && $accelZ !== null && $isFlat !== null) {
    // Use prepared statement to insert data
    $stmt = $conn->prepare("INSERT INTO sensor_data (accelX, accelY, accelZ, isFlat) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ddds", $accelX, $accelY, $accelZ, $isFlat);

    if ($stmt->execute()) {
        echo "Data inserted successfully";
    } else {
        echo "Error: " . $stmt->error;
    }
    $stmt->close();
} else {
    echo "Error: Missing required input values.";
}

$conn->close();
?>
