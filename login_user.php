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
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $con->connect_error]);
    exit;
}

if (isset($_POST['email'])) {
    $email = trim($_POST['email']);

    $stmt = $con->prepare('SELECT id, has_password, first_name, last_name, role_id FROM users WHERE email = ?');
    if ($stmt) {
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $stmt->bind_result($id, $has_password, $first_name, $last_name, $role_id);
            $stmt->fetch();

            $role_name = '';
            $role_stmt = $con->prepare('SELECT role FROM roles WHERE id = ? LIMIT 1');
            if ($role_stmt) {
                $role_stmt->bind_param('i', $role_id);
                $role_stmt->execute();
                $role_stmt->bind_result($role_result);
                if ($role_stmt->fetch()) {
                    $role_name = $role_result;
                }
                $role_stmt->close();
            }

            $user = [
                'id' => $id,
                'first_name' => $first_name,
                'last_name' => $last_name,
                 'email' => $email, 
                'role_id' => $role_id,
                'role_name' => $role_name,
                'has_password' => (int)$has_password,
            ];

            echo json_encode(['status' => 'success', 'user' => $user]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Email not found.']);
        }

        $stmt->close();
    } else {
        echo json_encode(['status' => 'error', 'message' => 'SQL error: ' . $con->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Email is required.']);
}

$con->close();
?>
