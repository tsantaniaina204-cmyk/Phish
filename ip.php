<?php
if (!empty($_POST['ip'])) {
    $ip = $_POST['ip'];
    $user_agent = $_SERVER['HTTP_USER_AGENT'];
    $data = "IP: " . $ip . " | User-Agent: " . $user_agent . "\n";
    file_put_contents("ip.txt", $data, FILE_APPEND);
}
?>
