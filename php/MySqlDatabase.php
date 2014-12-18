<?php
	class MySqlDatabase{
		private $connection;
		private $result;
		private $err_opening = "<font color=\"red\"><b>ERROR!</b><br/> ";
		
		function __construct($serv, $db, $un, $pw, $pt){
			
			$this -> connection = mysqli_connect($serv, $un, $pw, $db, $pt);
			
			if(mysqli_connect_errno()){
			
				die($this -> err_opening . "Database connection failed: " . mysqli_connect_error() . "</font>");
			
			}
			
		}
		
		function __destruct(){
			if( isset($this -> connection) ){
				
				mysqli_close($this -> connection);
				
				unset($this -> connection);
			}
		}
		
		public function execute($sql){
		
			$this -> result = mysqli_query($this -> connection, $sql);
			
			if(!$this -> result){
		
				$output = $this -> err_opening;
				$output .= "Database query failed: " .  "<br/>";
				$output .= "<small>Last SQL query: $sql <b>";
				$output .= "</b></small></font>";
			
				die($output);
				
			}
			
			return $this -> result;
		}
		
		public function storedProcedure($sql){
			
			$this -> result = mysqli_query($sql);
			

			if(!$this -> result){
		
				$output = $this -> err_opening;
				$output .= "Database query failed: " . mysql_error() . "<br/>";
				$output .= "<small>Last SQL query: <b>" . $this -> last_query;
				$output .= "</b></small></font>";
			
				die($output);
				
			}
			
			return $this -> result;
			
		}
		
		public function resultArray(){
	
			return mysqli_fetch_assoc($this -> result);
		
		}
		
		public function numRows(){
		
			return mysqli_num_rows($this -> result);
		
		}
		
		public function escapeString($string){
			
			return mysql_real_escape_string($string);
			
		}
	}
?>