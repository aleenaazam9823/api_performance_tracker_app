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
    echo json_encode(['status' => 'error', 'message' => 'DB connection failed: ' . $con->connect_error]);
    exit;
}

$role_id = isset($_POST['role_id']) ? intval($_POST['role_id']) : 0;

if ($role_id <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Role ID is required']);
    exit;
}

$dateToday = date('Y-m-d'); 

if ($role_id === 1) {
    // Admin: Get all conferences
    $query = "SELECT id, name, start_date, end_date, banner_image 
              FROM conferences 
              WHERE is_deleted = 0 
              ORDER BY start_date DESC";
    $stmt = $con->prepare($query);
} else {
    // Non-admin: Get only ongoing conferences
    $query = "SELECT id, name, start_date, end_date, banner_image 
              FROM conferences 
              WHERE is_deleted = 0 
                AND start_date <= ? 
                AND end_date >= ? 
              ORDER BY start_date DESC";
    $stmt = $con->prepare($query);
    if ($stmt === false) {
        echo json_encode(['status' => 'error', 'message' => 'SQL prepare error: ' . $con->error]);
        exit;
    }
    $stmt->bind_param('ss', $dateToday, $dateToday);
}

$stmt->execute();
$result = $stmt->get_result();

$conferences = [];

while ($row = $result->fetch_assoc()) {
    $conferences[] = $row;
}

echo json_encode([
    'status' => 'success',
    'conferences' => $conferences,
    'debug' => [
        'today' => $dateToday,
        'role_id' => $role_id,
        'count' => count($conferences),
    ],
]);

$stmt->close();
$con->close();
?>
