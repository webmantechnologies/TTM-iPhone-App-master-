<?php
require_once 'mmc/db.php';
?>
<html>
<head>
<title>City App - Management Console</title>
<script language="JavaScript"> 
var timeout_val = 2000;

setTimeout("timer_func()", timeout_val);

function timer_func(){ 
	document.getElementById("success").style.visibility = "visible";
} 
</script>
</head>
<body>
<div id="updating">Updating database. Please wait...</div>
<?php updateDB(); ?>
<div id="success" style="visibility: hidden">Database successfully updated!</div>
</body>
</html>
