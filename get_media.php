<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');

// === DB CONNECTION SETTINGS ===
$host = "localhost";
$dbname = "performance";
$username = "root";
$password = "";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "DB Connection Failed: " . $e->getMessage()
    ]);
    exit;
}

// Get sub_activity_id from GET or POST
$sub_activity_id = $_GET['sub_activity_id'] ?? $_POST['sub_activity_id'] ?? null;

if (!$sub_activity_id) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Missing required parameter: sub_activity_id"
    ]);
    exit;
}

try {
    // Fetch media for this sub_activity_id and not deleted
    $stmt = $pdo->prepare("SELECT media_upload AS file, media_type FROM sub_activity_media WHERE sub_activity_id = ? AND is_deleted = 0 ORDER BY uploaded_at DESC");
    $stmt->execute([$sub_activity_id]);
    $media = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "status" => "success",
        "sub_activity_id" => $sub_activity_id,
        "uploads" => $media
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . $e->getMessage()
    ]);
}
