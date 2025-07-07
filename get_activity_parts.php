<?php
header('Content-Type: application/json');

$host = "localhost";
$user = "root";
$pass = "";
$dbname = "performance";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit();
}

if (!isset($_GET['activity_id'])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Missing activity_id parameter"]);
    exit();
}

$activity_id = intval($_GET['activity_id']);

// Query activity parts for given activity_id and not deleted
$partsSql = "SELECT id, title, status, is_deleted FROM activity_parts 
             WHERE activity_id = ? AND is_deleted = 0";

$stmt = $conn->prepare($partsSql);
if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Prepare failed: " . $conn->error]);
    exit();
}
$stmt->bind_param("i", $activity_id);
$stmt->execute();
$partsResult = $stmt->get_result();

$activity_parts = [];

while ($part = $partsResult->fetch_assoc()) {
    $part_id = $part['id'];

    // Query responsibles for each activity part with users first and last name
    $respSql = "SELECT apr.id as apr_id, apr.activity_part_id, apr.responsible_id, apr.assigned_at, apr.is_deleted,
                       r.first_name, r.last_name
                FROM activity_part_responsibles apr
                LEFT JOIN users r ON apr.responsible_id = r.id
                WHERE apr.activity_part_id = ? AND apr.is_deleted = 0";

    $respStmt = $conn->prepare($respSql);
    if (!$respStmt) {
        http_response_code(500);
        echo json_encode(["success" => false, "message" => "Prepare failed: " . $conn->error]);
        exit();
    }
    $respStmt->bind_param("i", $part_id);
    $respStmt->execute();
    $respResult = $respStmt->get_result();

    $responsibles = [];
    while ($resp = $respResult->fetch_assoc()) {
        $fullName = trim($resp['first_name'] . ' ' . $resp['last_name']);
        $responsibles[] = [
            "activity_part_responsible_id" => $resp['apr_id'],
            "responsible_id" => $resp['responsible_id'],
            "name" => $fullName,
            "is_deleted" => (int)$resp['is_deleted'],
            "assigned_at" => $resp['assigned_at'],
        ];
    }

    $activity_parts[] = [
        "id" => $part['id'],
        "title" => $part['title'],
        "status" => $part['status'],
        "is_deleted" => (int)$part['is_deleted'],
        "responsibles" => $responsibles,
    ];

    $respStmt->close();
}

$stmt->close();
$conn->close();

echo json_encode([
    "success" => true,
    "data" => $activity_parts
]);
?>
