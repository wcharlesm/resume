<?php

require_once("../config/config.php");
include(INCL_PATH."ResumeIOC.php");

$method = $_SERVER['REQUEST_METHOD'];

switch ($method){
	case 'GET':		
		
		$response = $resumeFactory -> getFlatJobsArray(2);
		
		break;
	
	case 'POST':
		$response['output'] = 'post output';
		break;
}
	
header('Content-type: application/json');

echo json_encode($response);
?>