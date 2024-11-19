<?php
$ftp_server = "ftp.xxxxxxx.com"; 
$cid = ftp_connect($ftp_server) 
    or die("Couldn't connect to $ftp_server"); 

$login_result = ftp_login($cid, "user", "password"); 
if ((!$cid) || (!$login_result)) 
    die("FTP Connection Failed"); 

ftp_pasv($cid, true); // passive FTP connection (comment-out if needed)

// Pasta no servidor remota que deseja baixar
ftp_sync('/public_html/', './');

ftp_close($cid);

umask(0); // every directory will be chmod 777

function ftp_sync($_from = null, $_to = null) {
    
    global $cid;
    
    if (isset($_from)) {
        if (!ftp_chdir($cid, $_from)) die("Dir on FTP not found: $_from");
        if (isset($_to)) {
            if (!is_dir($_to)) @mkdir($_to);
            if (!chdir($_to)) die("Dir on local not exists? $_to"); 
        }
    }
    
    $contents = ftp_mlsd($cid, '.');
    
    foreach ($contents as $p) {
        
        if ($p['type'] != 'dir' && $p['type'] != 'file') continue;
        
        $file = $p['name'];
        
        echo ftp_pwd($cid).'/'.$file;
        
        if (file_exists($file) && !is_dir($file) && filemtime($file) >= strtotime($p['modify'])) {
            echo " [EXISTS AND CURRENT]";
        }
        elseif ($p['type'] == 'file' && @ftp_get($cid, $file, $file, FTP_BINARY)) {
            echo " [COPIED]";
        }
        elseif ($p['type'] == 'dir' && @ftp_chdir($cid, $file)) {
            echo "Dir changed to $file<br>\n";
            if (!is_dir($file)) mkdir($file);
            chdir($file);
            ftp_sync();
            ftp_chdir($cid, '..');
            chdir('..');
        }
        
        echo "<br>\n";
    }
}