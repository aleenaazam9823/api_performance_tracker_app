<?php
header('Content-Type: application/json');

// DB connection
$host = 'localhost';
$db   = 'performance';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database connection failed: ' . $e->getMessage(),
    ]);
    exit;
}

if (!isset($_GET['user_id'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Missing user_id',
    ]);
    exit;
}

$responsibleId = intval($_GET['user_id']); // renamed for clarity

// ✅ Use correct column: responsible_id
$query = "
    SELECT sa.id AS sub_activity_id, sa.title, sa.status
    FROM sub_activities sa
    INNER JOIN sub_activity_responsibles sar ON sa.id = sar.sub_activity_id
    WHERE sar.responsible_id = :responsibleId AND sar.is_deleted = 0
    GROUP BY sa.id
";

$stmt = $pdo->prepare($query);
$stmt->execute(['responsibleId' => $responsibleId]);
$subActivities = $stmt->fetchAll();

if (!$subActivities) {
    echo json_encode([
        'success' => true,
        'data' => [],
        'message' => 'No sub activities assigned to this user.'
    ]);
    exit;
}

$result = [];

foreach ($subActivities as $sub) {
    $subId = $sub['sub_activity_id'];

    // ✅ Again, use correct column: responsible_id
    $respQuery = "
        SELECT sar.responsible_id AS id, u.first_name, u.last_name, sar.is_deleted
        FROM sub_activity_responsibles sar
        JOIN users u ON u.id = sar.responsible_id
        WHERE sar.sub_activity_id = :subId
    ";

    $respStmt = $pdo->prepare($respQuery);
    $respStmt->execute(['subId' => $subId]);
    $responsibles = $respStmt->fetchAll();

    $result[] = [
        'id' => (int)$sub['sub_activity_id'],
        'title' => $sub['title'],
        'status' => $sub['status'],
        'responsibles' => array_map(function ($r) {
            return [
                'id' => (int)$r['id'],
                'first_name' => $r['first_name'],
                'last_name' => $r['last_name'],
                'isDeleted' => (bool)$r['is_deleted'],
            ];
        }, $responsibles),
    ];
}

echo json_encode([
    'success' => true,
    'data' => $result,
]);
