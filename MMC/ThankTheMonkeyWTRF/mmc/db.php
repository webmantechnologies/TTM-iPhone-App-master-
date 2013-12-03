<?

require_once 'phpgen_settings.php';

$result = GetGlobalConnectionOptions();
$dbfile = $result['database'];

function compressDB(){
	global $dbfile;

	$compdbfile = $dbfile . '.gz';
	$fp = fopen($dbfile, rb) or die("Can't open database file");
	$data = fread($fp, filesize($dbfile));
	fclose($fp);

	$fd = fopen($compdbfile, wb);
	$gzdata = gzencode($data, 9);
	fwrite($fd, $gzdata);
	fclose($fd);
}

function md5DB(){
	global $dbfile;

	$md5file = $dbfile . '.md5';
	$fh = fopen($md5file, w);
	$md5String = md5_file($dbfile);

	fwrite($fh, $md5String);
	fclose($fh);
}

function updateDB(){
	md5DB();
	compressDB();
}
?>