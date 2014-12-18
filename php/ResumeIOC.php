<?php

	require_once("config/dbconfig.php");
	
	require_once("getVars.php");
	
	require_once("MySqlDatabase.php");
	$resumeDb = new MySqlDatabase(DB_SERVER, DB_NAME, DB_USER, DB_PASS, DB_PORT);
	
	require_once("SqlResumeFactory.php");
	$resumeFactory = new SqlResumeFactory($resumeDb);
	
?>