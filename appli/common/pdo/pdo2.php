<?php

class PDO2 extends PDO {
	private static $instance;
	public function __construct(){
	}
	public static function getInstance(){
		if(!isset(self::$instance)){
			try{
				self::$instance = new PDO(
					SQL_DSN,
					SQL_USERNAME,
					SQL_PASSWORD,
					array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8", PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
			} catch (PDOExcepion $e) {
				echo $e;
			}
		}
		return self::$instance;
	}
}
?>