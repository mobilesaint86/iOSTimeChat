<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Database extends CI_Controller {

        function export_users()
        {
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
				$date = date('YmdHis');
				$filename ="csv/".$date.".csv";
                $fp = fopen($filename, "w");
				$this->load->model('tbl_users');
                $items = $this->tbl_users->getData();
				
				// fetch a row and write the column names out to the file
				$row = $items[0];
				$line = "";
				$comma = "";
				foreach($row as $name => $value) {
					if ($name != "token") {
						$line .= $comma . '"' . str_replace('"', '""', $name) . '"';
						$comma = ",";
					}
				}
				$line .= "\n";
				fputs($fp, $line);

				// and loop through the actual data
				for ($i=1; $i<count($items);$i++){
				    $row = $items[$i];
					$line = "";
					$comma = "";
					$col_num = 0;
					foreach($row as $value) {
							if ($col_num != 7){
								$line .= $comma . '"' . str_replace('"', '""', $value) . '"';
								$comma = ",";
							}
							$col_num++;	
					}
					$line .= "\n";
					fputs($fp, $line);
				}

				fclose($fp);				
				echo $filename;
			}
		}
		function export_orders()
        {
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
				$date = date('YmdHis');
				$filename ="csv/".$date.".csv";
                $fp = fopen($filename, "w");
				$this->load->model('tbl_items');
				$this->load->model('tbl_barcodes');
                $items = $this->tbl_items->getData();
				
				// fetch a row and write the column names out to the file
				$row = $items[0];
				$line = "";
				$comma = "";
				// foreach($row as $name => $value){
						// if ($name != "id"){
							// $line .= $comma . '"' . str_replace('"', '""', $name) . '"';
							// $comma = ",";
						// }
				// }
				$line .= $comma . '"' . str_replace('"', '""', "Barcode") . '"';
				$comma = ",";
				$line .= $comma . '"' . str_replace('"', '""', "Quantity") . '"';
				$line .= $comma . '"' . str_replace('"', '""', "Description") . '"';
				$line .= "\n";
				fputs($fp, $line);

				// and loop through the actual data
				for ($i=1; $i<count($items);$i++){
				    $row = $items[$i];
					$line = "";
					$comma = "";
					foreach($row as $name => $value) {
							if ($name == "barcode_id"){
								$barcode = $this->tbl_barcodes->getDataById($value);
								if (count($barcode) > 0){
									$line .= $comma . '"' . str_replace('"', '""', $barcode[0]['barcode']) . ' "';
									$comma = ",";
								} else {
									$line .= $comma . '"' . str_replace('"', '""', "") . '"';
									$comma = ",";									
								}
							}
					}
					foreach($row as $name => $value) {
							if ($name == "quantity"){
								$line .= $comma . '"' . str_replace('"', '""', $value) . '"';
								$comma = ",";								
							}
					}					
					foreach($row as $name => $value) {
							if ($name == "barcode_id"){
								$barcode = $this->tbl_barcodes->getDataById($value);
								if (count($barcode) > 0){
									$line .= $comma . '"' . str_replace('"', '""', $barcode[0]['description']) . '"';
									$comma = ",";
								} else {
									$line .= $comma . '"' . str_replace('"', '""', "") . '"';
									$comma = ",";									
								}
							} 
					}
					$line .= "\n";
					fputs($fp, $line);
				}

				fclose($fp);				
				echo $filename;
			}
		}		
		function import()
        {
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
				$posts = $this->input->post();
				ini_set("display_errors",1);
				error_reporting(E_ALL);
				require_once 'excel_reader2.php';
				$xls = new Spreadsheet_Excel_Reader("xls/customers.xls");
				if ($posts['type'] == 'user'){
					for ($row=2;$row<=$xls->rowcount();$row++) { 	
						 $exist = 0;
						 for ($col=1;$col<$xls->colcount();$col++) {							
							if ($xls->val($row,$col) != '')  $exist = 1;
						 }
						 if ($exist){
							$data[$row-2]['id'] = $xls->val($row,7);
							$data[$row-2]['username'] = $xls->val($row,2);
							$data[$row-2]['password'] = $xls->val($row,3);
							$data[$row-2]['company'] = $xls->val($row,4);
							$data[$row-2]['email'] = $xls->val($row,5);
						 }
					}
					$this->load->model('tbl_users');
					$return = 1;
					for ($i=0;$i<count($data);$i++){
						if (count($this->tbl_users->getDataById($data[$i]['id'])) > 0)
							$result = $this->tbl_users->save($data[$i]);
						else {
							$result = $this->tbl_users->add($data[$i]);
						}
						$return *= $result;
					}
				} else if ($posts['type'] == 'barcode') {
					for ($row=2;$row<=$xls->rowcount();$row++) { 	
						 $exist = 0;
						 for ($col=1;$col<$xls->colcount();$col++) {							
							if ($xls->val($row,$col) != '')  $exist = 1;
						 }
						 if ($exist){
							$data[$row-2]['barcode'] = $xls->val($row,1);
							$data[$row-2]['description'] = $xls->val($row,2);
						 }
					}
					$this->load->model('tbl_barcodes');
					$return = 1;
					for ($i=0;$i<count($data);$i++){
						if (count($this->tbl_barcodes->getDataByBarcode($data[$i]['barcode'])) > 0)
							$result = $this->tbl_barcodes->save($data[$i]);
						else {
							$result = $this->tbl_barcodes->add($data[$i]);
						}
						$return *= $result;
					}		
				}
				$file = "xls/customers.xls";
				if (!unlink($file))
					$return = 0;
				else
					$return = 1;
				if ($result==0) echo 0;
				else echo 1;
            }
		}
}
