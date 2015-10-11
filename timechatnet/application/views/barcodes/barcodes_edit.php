<div class="container" style="margin-top:40px">
	<h1>Edit Barcode</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onEditBarcodes_Back();">Back</a>
</div> <!-- /container -->

	<div class="container" id="client_row">
            <div id="client_row_div">
<form id="myForm">
					<div>
                        <div class="edit_text1">Barcode :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="barcode" value="<?php echo $barcodes['barcode'];?>" class="required" style="width:100%;"></div>
                    </div>
					<div>
                        <div class="edit_text1">Description :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="description" value="<?php echo $barcodes['description'];?>" class="required" style="width:100%;" ></div>
                    </div>
                    <div style="margin-top:20px;text-align: right;width:81%;">
	                <button class="btn btn-large btn-primary" onclick="onBarcodes_Edit_Submit(<?php echo $barcodes['id'];?>);">Submit</button>
                    </div>
</form>
          </div>
 </div>    