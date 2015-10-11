<!----------------------Podcasts add---------------->
<div class="container" style="margin-top:40px">
	<h1>Add User</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onEditUsers_Back();">Back</a>
</div> <!-- /container -->

	<div class="container" id="client_row">
		<div id="client_row_div">
			<form id="myForm">
				<div style="margin-top:20px;">
					<div class="edit_text1"> email:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="email" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> username:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="username" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> password:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="password" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> confirmed_value:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="confirmed_value" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> role:&nbsp;</div>
					<div class="edit_input1">
						<select id="role">
							<option selected>user</option>
							<option>admin</option>
						</select>
					</div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> social_type:&nbsp;</div>
					<div class="edit_input1">
						<select id="social_type">
							<option selected>email</option>
							<option>facebook</option>
							<option>twitter</option>
							<option>google</option>
						</select>
					</div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> time_zone:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="time_zone" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> push_enable:&nbsp;</div>
					<div class="edit_input1" style="height:40px;"><input type="checkbox" class="required" id="push_enable"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> sound_enable:&nbsp;</div>
					<div class="edit_input1"  style="height:40px;"><input type="checkbox" id="sound_enable" class="required"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> theme_type:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="theme_type" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> push_sound:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="push_sound" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> user_status:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="user_status" class="required"  style="width:350px;" maxlength=25></div>
				</div>

				<div style="margin-top:20px;">
					<div class="edit_text1"> auto_accept_friend:&nbsp;</div>
					<div class="edit_input1" style="height:40px;"><input type="checkbox" class="required" id="auto_accept_friend:"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> auto_notify_friend:&nbsp;</div>
					<div class="edit_input1"  style="height:40px;"><input type="checkbox" id="auto_notify_friend:" class="required"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> avatar:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="avatar" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> authentication_token:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="authentication_token" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;text-align: right;width:81%;">
					<button class="btn btn-large btn-primary"  type="submit" onclick="onUsers_Add_Submit();">Submit</button>
				</div>
			</form>
		</div>
	</div>

    <script>
        $("#username").focus();
    </script>