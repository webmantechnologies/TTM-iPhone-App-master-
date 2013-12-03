<?
function convertImage($fileName){
	$data["converted_file_extension"] = "png";

	// Aplicando escalado con ImageMagick
	list($width, $height, $type, $attr) = getimagesize($fileName);

	if($width >= $height)
		exec('/usr/bin/convert ' . $fileName . " -resize x200 -quality 100 " . $fileName);
	else
		exec('/usr/bin/convert ' . $fileName . " -resize 200x -quality 100 " . $fileName);

	//ANTERIOR: exec('/usr/bin/convert ' . $fileName . " -resize x200 -quality 100 " . $fileName);

	// Aplicando conversion a PNG
	exec('/usr/bin/mogrify -format png ' . $fileName);

	$data["newFileName"] = $fileName . "." . $data["converted_file_extension"];
	$data["newFileSize"] = filesize($newValue);

	// Calculo del MD5 del archivo
	$data["md5Name"] = md5_file($data["newFileName"]) . "." . $data["converted_file_extension"];

	return $data;
}
?>
