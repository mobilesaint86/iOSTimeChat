<?php
    switch ($page)
    {
		case "barcodes":
          include_once("barcodes.php");
          break;        
        case "barcodes_edit":
          include_once("barcodes_edit.php");
          break;
        case "barcodes_details":
          include_once("barcodes_details.php");
          break;
      case "barcodes_add":
          include_once("barcodes_add.php");
          break;
        default:
          break;
    }
?>