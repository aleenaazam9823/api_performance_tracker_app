<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// === DB CONNECTION SETTINGS ===
$host = "localhost";
$dbname = "performance";
$username = "root";
$password = "";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode([
        "status" => "error",
        "message" => "DB Connection Failed: " . $e->getMessage()
    ]));
}

// === UPLOAD DIRECTORY SETUP ===
$baseDir = __DIR__;
$uploadDir = $baseDir . '/uploads/';
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

// === BASE URL CONSTRUCTION ===
$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? "https://" : "http://";
$host = $_SERVER['HTTP_HOST'];
$basePath = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/\\');
$baseUrl = $protocol . $host . $basePath . '/';

// === INPUT VALIDATION ===
$requiredFields = ['sub_activity_id', 'completed_by'];
foreach ($requiredFields as $field) {
    if (empty($_POST[$field])) {
        echo json_encode([
            "status" => "error",
            "message" => "Missing required field: $field"
        ]);
        exit;
    }
}

$sub_activity_id = $_POST['sub_activity_id'];
$remark = $_POST['remark'] ?? null;
$completed_by = $_POST['completed_by'];
$is_deleted = 0;
$uploaded_at = date('Y-m-d H:i:s');

// === ALLOWED FILE EXTENSIONS ===
$allowedImageExt = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
$allowedVideoExt = ['mp4', 'mov', 'avi', 'mkv', 'webm', 'flv', 'wmv'];

// === RESPONSE ARRAY ===
$response = [];

if (!empty($_FILES['media_upload']['name'][0])) {
    $fileCount = count($_FILES['media_upload']['name']);

    for ($i = 0; $i < $fileCount; $i++) {
        if ($_FILES['media_upload']['error'][$i] == UPLOAD_ERR_NO_FILE) {
            continue;
        }

        if ($_FILES['media_upload']['error'][$i] !== UPLOAD_ERR_OK) {
            $response[] = [
                "file" => $_FILES['media_upload']['name'][$i],
                "status" => "failed",
                "reason" => "Upload error code: " . $_FILES['media_upload']['error'][$i]
            ];
            continue;
        }

        $originalName = $_FILES['media_upload']['name'][$i];
        $tmpPath = $_FILES['media_upload']['tmp_name'][$i];

        $ext = strtolower(pathinfo($originalName, PATHINFO_EXTENSION));
        $mediaType = null;

        if (in_array($ext, $allowedImageExt)) {
            $mediaType = 'image';
        } elseif (in_array($ext, $allowedVideoExt)) {
            $mediaType = 'video';
        } else {
            $response[] = [
                "file" => $originalName,
                "status" => "failed",
                "reason" => "Unsupported file extension: .$ext"
            ];
            continue;
        }

        $safeName = preg_replace("/[^a-zA-Z0-9\._-]/", "_", basename($originalName));
        $newName = uniqid() . '_' . $safeName;
        $targetPath = $uploadDir . $newName;

        if (move_uploaded_file($tmpPath, $targetPath)) {
            $relativePath = 'uploads/' . $newName;
            $fileUrl = $baseUrl . $relativePath;

            try {
                // Insert uploaded file info
                $stmt = $pdo->prepare("
                    INSERT INTO sub_activity_media 
                    (sub_activity_id, media_upload, media_type, uploaded_at, remark, is_deleted, completed_by)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                ");
                $stmt->execute([
                    $sub_activity_id,
                    $fileUrl,
                    $mediaType,
                    $uploaded_at,
                    $remark,
                    $is_deleted,
                    $completed_by
                ]);

                // Update sub_activity to completed
                $updateStmt = $pdo->prepare("
                    UPDATE sub_activities 
                    SET status = 'completed', modified_at = NOW() 
                    WHERE id = ?
                ");
                $updateStmt->execute([$sub_activity_id]);

                // === CHECK IF ALL SUB-ACTIVITIES ARE COMPLETED ===
                $getPartStmt = $pdo->prepare("SELECT activity_parts_id FROM sub_activities WHERE id = ?");
                $getPartStmt->execute([$sub_activity_id]);
                $activityPartId = $getPartStmt->fetchColumn();

                if ($activityPartId) {
                    // Check if any remaining sub-activities are still not completed
                    $checkIncompleteStmt = $pdo->prepare("
                        SELECT COUNT(*) FROM sub_activities 
                        WHERE activity_parts_id = ? AND status != 'completed' AND is_deleted = 0
                    ");
                    $checkIncompleteStmt->execute([$activityPartId]);
                    $incompleteCount = $checkIncompleteStmt->fetchColumn();

                    if ($incompleteCount == 0) {
                        // All sub-activities completed; mark the activity_part as completed
                        $updatePartStmt = $pdo->prepare("
                            UPDATE activity_parts 
                            SET status = 'completed' 
                            WHERE id = ?
                        ");
                        $updatePartStmt->execute([$activityPartId]);
                    }
                }

                $response[] = [
                    "file" => $fileUrl,
                    "status" => "success",
                    "media_type" => $mediaType,
                    "file_name" => $newName,
                    "original_name" => $originalName
                ];
            } catch (PDOException $e) {
                unlink($targetPath);
                $response[] = [
                    "file" => $originalName,
                    "status" => "failed",
                    "reason" => "Database error: " . $e->getMessage()
                ];
            }
        } else {
            $response[] = [
                "file" => $originalName,
                "status" => "failed",
                "reason" => "Failed to move uploaded file"
            ];
        }
    }

    echo json_encode([
        "status" => "completed",
        "base_url" => $baseUrl,
        "uploads_dir" => $uploadDir,
        "uploads" => $response
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No files received"
    ]);
}
?>
    