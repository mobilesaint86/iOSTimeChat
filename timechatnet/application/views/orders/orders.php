<!----------------------Pod Casts---------------->
<div class="container" style="margin-top:40px">
	<h1>Orders Summary</h1>
</div> <!-- /container -->

        <div class="container" id="client_row" style="margin-top:40px;">
            <div id="client_row_div">
                        <div id="content_2" class="container">
                                    <table class="main table tablesorter" id="sortTableExample" border="1" style="width: 100%;border-color:white;">
                                        <thead>
                                            <tr class="tr_height">
                                              <th class="header" style="width:4%;font-size:12px;">Id</th>
											  <th class="header" style="font-size:12px;">username</th>
                                              <th class="header" style="font-size:12px;">datetime</th>
											  <th class="header" style="font-size:12px;">ship_date</th>
                                              <th class="header" style="font-size:12px;">comment</th>
                                              <th class="header" style="font-size:12px;">quantity</th>                                              
											  <th class="header" style="font-size:12px;">Action</th>                                              
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                                for ($i=0;$i<count($orders);$i++){
                                            ?>
                                            <tr class="tr_height" id="<?php echo $orders[$i]['id'];?>">
                                                <td><?php echo $orders[$i]['id'];?></td>
												<td><?php echo $orders[$i]['username'];?></td>
                                                <td><?php echo $orders[$i]['datetime'];?></td>
                                                <td><?php echo $orders[$i]['ship_date'];?></td>
                                                <td><?php echo $orders[$i]['comment'];?></td>
                                                <td><?php echo $orders[$i]['quantity'];?></td>                                                
                                                <td><div class="btn-group">
							  <a class="btn btn-primary btn-small" href="#"><i class="icon-th icon-white"></i> Action</a>
							  <a class="btn btn-primary btn-small dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
							  <ul class="dropdown-menu">
							    <li><a href="javascript: onOrdersDetails(<?php echo $orders[$i]['id'];?>);"><i class="icon-info-sign icon-white"></i> Details</a></li>
							    <li><a href="javascript: onOrdersEdit(<?php echo $orders[$i]['id'];?>);"><i class="icon-pencil icon-white"></i> Edit</a></li>
							  </ul>
						</div></td>
                                            </tr>
                                            <?php
                                                }
                                            ?>
                                        </tbody>
                                    </table>
                        </div>
            </div>
        </div>    