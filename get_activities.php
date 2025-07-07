<?php
// db_config.php - include your database credentials here or include this file
$host = 'localhost';
$dbname = 'performance';
$user = 'root';
$password = '';

try {
    // Create PDO instance
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Check if conference_id is provided in GET request
    if (!isset($_GET['conference_id']) || empty($_GET['conference_id'])) {
        throw new Exception('conference_id parameter is required');
    }

    $conference_id = $_GET['conference_id'];

    // Prepare query with parameter binding to prevent SQL injection
    $stmt = $pdo->prepare("SELECT id, conference_id, title, status, percent_complete, is_deleted FROM activities WHERE is_deleted = 0 AND conference_id = :conference_id");
    $stmt->bindParam(':conference_id', $conference_id, PDO::PARAM_INT);
    $stmt->execute();

    $activities = $stmt->fetchAll(PDO::FETCH_ASSOC);

    header('Content-Type: application/json');
    echo json_encode([
        'success' => true,
        'data' => $activities
    ]);

} catch (Exception $e) {
    header('Content-Type: application/json');
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
    exit;
}
?>
