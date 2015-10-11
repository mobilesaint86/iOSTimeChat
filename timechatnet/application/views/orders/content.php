<?php
    switch ($page)
    {
		case "orders":
          include_once("orders.php");
          break;        
        case "orders_edit":
          include_once("orders_edit.php");
          break;
        case "orders_details":
          include_once("orders_details.php");
          break;
      case "orders_add":
          include_once("orders_add.php");
          break;
        default:
          break;
    }
?>