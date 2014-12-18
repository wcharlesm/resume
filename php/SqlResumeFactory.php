<?php

class SqlResumeFactory {
	private $db;
	
	function __construct($db){
		$this -> db = $db;
	}
	
	function getFlatCertificationsArray($personId){
		$query = "SELECT * FROM certification WHERE personid=$personId";
		
		$this -> db -> execute($query);
		
		$resumeArray = Array();
		$index = 0;
		
		while ($row = $this -> db -> resultArray()) {
			$resumeArray[$index++] = Array (
				'name' => trim($row['name']),
				'organization' => trim($row['organization']),
				'dateReceived' => trim($row['datereceived'])
			);
		}
		
		return $resumeArray;
	}
	
	function getFlatJobsArray($personId){
		
		$query = "CALL sp_resumebypersonid($personId)";
		
		$this -> db -> execute($query);
		
		$resumeArray = Array();
		$index = 0;
		
		while ($row = $this -> db -> resultArray()) {
			$resumeArray[$index++] = Array (
				'personName' => trim($row['personname']),
				'email' => trim($row['email']),
				'phone' => trim($row['phone']),
				'companyName' => trim($row['companyname']),
				'companyStartDate' => trim($row['companystartdate']),
				'companyEndDate' => trim($row['companyenddate']),
				'positionName' => trim($row['positionname']),
				'positionStartDate' => trim($row['positionstartdate']),
				'positionEndDate' => trim($row['positionenddate']),
				'positionDescription' => trim($row['positiondescription']),
				'responsibilityDescription' => trim($row['responsibilitydescription'])
			);
		}
		
		return $resumeArray;
		
	}
	
	function getFlatSkillsArray($personId) {
		
		$query = "CALL sp_skillsbypersonid($personId)";

		
		$this -> db -> execute($query);
		
		$skillArray = Array();
		$index = 0;
		
		while ($row = $this -> db -> resultArray()) {
			$skillArray[$index++] = Array (
				'skillname' => trim($row['skillname']),
				'companyname' => trim($row['companyname']),
				'positionname' => trim($row['positionname']),
				'responsibilitydescription' => trim($row['responsibilitydescription']),
				'certificationname' => trim($row['certificationname'])
			);
		}
		
		return $skillArray;
	}
}

?>