<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

// Simple DB connection
$host = "localhost";
$dbname = "performance";
$username = "root";
$password = "";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed: " . $e->getMessage()
    ]);
    exit;
}

// Get POST data
$conferenceId = $_POST['conference_id'] ?? null;
$userId = $_POST['user_id'] ?? null;
$title = $_POST['title'] ?? null;
$message = $_POST['message'] ?? null;

if (!$conferenceId || !$userId || !$title || !$message) {
    echo json_encode([
        "status" => "error",
        "message" => "conference_id, user_id, title and message are required"
    ]);
    exit;
}

try {
    // Insert into notifications table
    $stmt = $pdo->prepare("
        INSERT INTO notifications (conference_id, user_id, title, message, created_at, is_deleted)
        VALUES (?, ?, ?, ?, NOW(), 0)
    ");
    $stmt->execute([$conferenceId, $userId, $title, $message]);

    echo json_encode([
        "status" => "success",
        "message" => "Notification created successfully"
    ]);

} catch (PDOException $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . $e->getMessage()
    ]);
}
?>
