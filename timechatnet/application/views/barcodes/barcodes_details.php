<div class="container" style="margin-top:40px">
	<h1>Barcodes Details</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onEditBarcodes_Back();">Back</a>
</div> <!-- /container -->

	<div class="container" id="client_row">
            <div id="client_row_div">
<form id="myForm">
                    <div style="margin-top:20px;">
                        <div class="edit_text1">Id :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="id" value="<?php echo $barcodes['id'];?>" class="required" style="width:100%;"></div>
                    </div>
					<div>
                        <div class="edit_text1">Barcode :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="barcode" value="<?php echo $barcodes['barcode'];?>" class="required" style="width:100%;"></div>
                    </div>
					<div>
                        <div class="edit_text1">Description :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="description" value="<?php echo $barcodes['description'];?>" class="required" style="width:100%;" ></div>
                    </div>
</form>
          </div>
 </div>