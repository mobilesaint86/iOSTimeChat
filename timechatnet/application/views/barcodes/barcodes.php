<!----------------------Pod Casts---------------->
<div class="container" style="margin-top:40px">
	<h1>Barcodes Summary</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onAddBarcode();">Add Recorded Barcode</a>
</div> <!-- /container -->

        <div class="container" id="client_row" style="margin-top:40px;">
            <div id="client_row_div">
                        <div id="content_2" class="container">
                                    <table class="main table tablesorter" id="sortTableExample" border="1" style="width: 100%;border-color:white;">
                                        <thead>
                                            <tr class="tr_height">
                                              <th class="header" style="width:4%;font-size:12px;">Id</th>
											  <th class="header" style="font-size:12px;">barcode</th>
                                              <th class="header" style="font-size:12px;">description</th>
											  <th class="header" style="font-size:12px;">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                                for ($i=0;$i<count($barcodes);$i++){
                                            ?>
                                            <tr class="tr_height" id="<?php echo $barcodes[$i]['id'];?>">
                                                <td><?php echo $barcodes[$i]['id'];?></td>
												<td><?php echo $barcodes[$i]['barcode'];?></td>
                                                <td><?php echo $barcodes[$i]['description'];?></td>
                                                <td><div class="btn-group">
							  <a class="btn btn-primary btn-small" href="#"><i class="icon-th icon-white"></i> Action</a>
							  <a class="btn btn-primary btn-small dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
							  <ul class="dropdown-menu">
							    <li><a href="javascript: onBarcodesDetails(<?php echo $barcodes[$i]['id'];?>);"><i class="icon-info-sign icon-white"></i> Details</a></li>
								<li><a href="javascript: onBarcodesEdit(<?php echo $barcodes[$i]['id'];?>);"><i class="icon-info-sign icon-white"></i> Edit</a></li>
								<li><a href="javascript: onBarcodesDelete(<?php echo $barcodes[$i]['id'];?>);"><i class="icon-info-sign icon-white"></i> Delete</a></li>
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