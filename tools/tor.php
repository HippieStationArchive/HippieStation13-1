<?php

function cURLDownload($url)
{
    if (!function_exists('curl_init')){
        die('cURL PHP Extension not enabled!');
    }

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5);
    $output = curl_exec($ch);
    curl_close($ch);

    return $output;
}

print cURLDownload('https://check.torproject.org/exit-addresses');
?>
