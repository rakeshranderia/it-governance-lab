<?php

$config = require '/etc/assetlab-db.php';

try {
    $pdo = new PDO(
        $config['dsn'],
        $config['user'],
        $config['password'],
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    );

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {

        $action = $_POST['action'] ?? 'add';

        if ($action === 'add') {
            $assetName = trim($_POST['asset_name'] ?? '');
            $assetType = trim($_POST['asset_type'] ?? '');
            $status = trim($_POST['status'] ?? '');

            if ($assetName !== '' && $assetType !== '' && $status !== '') {
                $stmt = $pdo->prepare(
                    'INSERT INTO assets (asset_name, asset_type, status)
                     VALUES (:asset_name, :asset_type, :status)'
                );

                $stmt->execute([
                    ':asset_name' => $assetName,
                    ':asset_type' => $assetType,
                    ':status' => $status
                ]);
            }
        }

        if ($action === 'update') {
            $id = (int)($_POST['id'] ?? 0);
            $status = trim($_POST['status'] ?? '');

            if ($id > 0 && $status !== '') {
                $stmt = $pdo->prepare(
                    'UPDATE assets
                     SET status = :status
                     WHERE id = :id'
                );

                $stmt->execute([
                    ':status' => $status,
                    ':id' => $id
                ]);
            }
        }

        if ($action === 'delete') {
            $id = (int)($_POST['id'] ?? 0);

            if ($id > 0) {
                $stmt = $pdo->prepare(
                    'DELETE FROM assets
                     WHERE id = :id'
                );

                $stmt->execute([
                    ':id' => $id
                ]);
            }
        }

        header('Location: /assets.php');
        exit;
    }

    $assets = $pdo->query(
        'SELECT id, asset_name, asset_type, status
         FROM assets
         ORDER BY id'
    )->fetchAll();

} catch (PDOException $e) {
    http_response_code(500);
    exit('Database operation failed.');
}

$statuses = [
    'Active',
    'In Stock',
    'Repair',
    'Retired'
];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Asset Lab</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }

        .add-form {
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ccc;
            width: 760px;
        }

        input, select, button {
            padding: 6px;
            margin: 3px;
        }

        table {
            border-collapse: collapse;
            width: 800px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }

        th {
            background: #eee;
        }

        form.inline {
            display: inline;
        }
    </style>
</head>
<body>

<h1>IT Asset Register</h1>

<h2>Add Asset</h2>

<form method="post" class="add-form">
    <input type="hidden" name="action" value="add">

    <input
        type="text"
        name="asset_name"
        placeholder="Asset name"
        required
    >

    <input
        type="text"
        name="asset_type"
        placeholder="Asset type"
        required
    >

    <select name="status" required>
        <?php foreach ($statuses as $status): ?>
            <option value="<?= htmlspecialchars($status) ?>">
                <?= htmlspecialchars($status) ?>
            </option>
        <?php endforeach; ?>
    </select>

    <button type="submit">Add Asset</button>
</form>

<h2>Assets</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Asset</th>
            <th>Type</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>

    <tbody>
    <?php foreach ($assets as $asset): ?>
        <tr>
            <td><?= htmlspecialchars($asset['id']) ?></td>
            <td><?= htmlspecialchars($asset['asset_name']) ?></td>
            <td><?= htmlspecialchars($asset['asset_type']) ?></td>

            <td>
                <form method="post" class="inline">
                    <input type="hidden" name="action" value="update">
                    <input
                        type="hidden"
                        name="id"
                        value="<?= htmlspecialchars($asset['id']) ?>"
                    >

                    <select name="status">
                        <?php foreach ($statuses as $status): ?>
                            <option
                                value="<?= htmlspecialchars($status) ?>"
                                <?= $asset['status'] === $status ? 'selected' : '' ?>
                            >
                                <?= htmlspecialchars($status) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>

                    <button type="submit">Update</button>
                </form>
            </td>

            <td>
                <form method="post" class="inline">
                    <input type="hidden" name="action" value="delete">
                    <input
                        type="hidden"
                        name="id"
                        value="<?= htmlspecialchars($asset['id']) ?>"
                    >

                    <button type="submit">Delete</button>
                </form>
            </td>
        </tr>
    <?php endforeach; ?>
    </tbody>
</table>

</body>
</html>
