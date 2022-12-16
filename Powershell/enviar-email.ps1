$smtpServer = "smtp.office365.com";
$port = 587;
$username = "";
$password = "";
$from = "";
$to = "";
$subject = "teste";
$body = "corpo da mensagem";

$Message = New-Object System.Net.Mail.MailMessage $from,$to;
$Message.IsBodyHTML = $true;
$Message.Subject = $subject;
$Message.Body = $body;

$Smtp = New-Object Net.Mail.SmtpClient($smtpServer,$port);
$Smtp.Credentials = New-Object System.Net.NetworkCredential($username,$password);
$Smtp.EnableSsl = $true;
$Smtp.Send($Message);