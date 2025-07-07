<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = 'localhost';
$user = 'root';
$pass = '';
$dbname = 'performance';

$con = new mysqli($host, $user, $pass, $dbname);
if ($con->connect_error) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed: ' . $con->connect_error
    ]);
    exit;
}

$id = isset($_POST['id']) ? intval($_POST['id']) : 0;
$password = isset($_POST['password']) ? trim($_POST['password']) : '';

if ($id <= 0 || empty($password)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'User ID and password are required.'
    ]);
    exit;
}

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

$stmt = $con->prepare("UPDATE users SET password = ?, has_password = 1 WHERE id = ?");
if ($stmt) {
    $stmt->bind_param("si", $hashedPassword, $id);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Password set successfully.'
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'No matching user found or password already set.'
        ]);
    }

    $stmt->close();
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'SQL Error: ' . $con->error
    ]);
}

$con->close();
?>
