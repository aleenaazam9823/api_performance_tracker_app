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

if (!isset($_GET['activity_part_id'])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Missing activity_part_id parameter"]);
    exit();
}

$activity_part_id = intval($_GET['activity_part_id']);

// Query sub_activities for given activity_part_id and not deleted
$subActivitiesSql = "SELECT id, title, status, is_deleted, created_at, modified_at 
                     FROM sub_activities 
                     WHERE activity_parts_id = ? AND is_deleted = 0";

$stmt = $conn->prepare($subActivitiesSql);
if (!$stmt) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Prepare failed: " . $conn->error]);
    exit();
}
$stmt->bind_param("i", $activity_part_id);
$stmt->execute();
$subActivitiesResult = $stmt->get_result();

$sub_activities = [];

while ($sub = $subActivitiesResult->fetch_assoc()) {
    $sub_id = $sub['id'];

    // Query responsibles for each sub_activity with users first and last name
    $respSql = "SELECT sar.id as sar_id, sar.sub_activity_id, sar.responsible_id, sar.assigned_at, sar.is_deleted,
                       u.first_name, u.last_name
                FROM sub_activity_responsibles sar
                LEFT JOIN users u ON sar.responsible_id = u.id
                WHERE sar.sub_activity_id = ? AND sar.is_deleted = 0";

    $respStmt = $conn->prepare($respSql);
    if (!$respStmt) {
        http_response_code(500);
        echo json_encode(["success" => false, "message" => "Prepare failed: " . $conn->error]);
        exit();
    }
    $respStmt->bind_param("i", $sub_id);
    $respStmt->execute();
    $respResult = $respStmt->get_result();

    $responsibles = [];
    while ($resp = $respResult->fetch_assoc()) {
        $fullName = trim($resp['first_name'] . ' ' . $resp['last_name']);
       $responsibles[] = [
    "sub_activity_responsible_id" => $resp['sar_id'],
    "responsible_id" => $resp['responsible_id'],
    "first_name" => $resp['first_name'],    // send separately
    "last_name" => $resp['last_name'],      // send separately
    "is_deleted" => (int)$resp['is_deleted'],
    "assigned_at" => $resp['assigned_at'],
];

    }

    $sub_activities[] = [
        "id" => $sub['id'],
        "title" => $sub['title'],
        "status" => $sub['status'],
        "is_deleted" => (int)$sub['is_deleted'],
        "created_at" => $sub['created_at'],
        "modified_at" => $sub['modified_at'],
        "responsibles" => $responsibles,
    ];

    $respStmt->close();
}

$stmt->close();
$conn->close();

echo json_encode([
    "success" => true,
    "data" => $sub_activities
]);
?>
