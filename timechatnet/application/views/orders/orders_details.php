<div class="container" style="margin-top:40px">
	<h1>Orders Details</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onEditOrders_Back();">Back</a>
</div> <!-- /container -->

	<div class="container" id="client_row">
            <div id="client_row_div">
<form id="myForm">
                    <div style="margin-top:20px;">
                        <div class="edit_text1">Id :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="id" value="<?php echo $orders['id'];?>" class="required" style="width:100%;"></div>
                    </div>
					<div>
                        <div class="edit_text1">Username :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="user_id" value="<?php echo $orders['username'];?>" class="required" style="width:100%;"></div>
                    </div>
					<div>
                        <div class="edit_text1">Datetime :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="address" value="<?php echo $orders['datetime'];?>" class="required" style="width:100%;" ></div>
                    </div>
                    <div>
                        <div class="edit_text1">Ship_date :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="ship_date" value="<?php echo $orders['ship_date'];?>" class="required" style="width:100%;" ></div>
                    </div>
                    <div>
                        <div class="edit_text1">Comment :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="comment" value="<?php echo $orders['comment'];?>" class="required" style="width:100%;" ></div>
                    </div>
                    <div>
                        <div class="edit_text1">Quantity :&nbsp;</div>
                        <div class="edit_input1"><input type="text" id="quantity" value="<?php echo $orders['quantity'];?>" class="required" style="width:100%;"></div>
                    </div>                    
</form>
          </div>
 </div>