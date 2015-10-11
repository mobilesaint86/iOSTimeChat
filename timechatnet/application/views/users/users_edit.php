<div class="container" style="margin-top:40px">
	<h1>Edit User</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onEditUsers_Back();">Back</a>
</div> <!-- /container -->

<div class="container" id="client_row">
	<div id="client_row_div">
		<form id="myForm">
			<div style="margin-top:20px;">
				<div class="edit_text1"> email:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="email" class="required" value="<?php echo $users['email'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> username:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="username" class="required" value="<?php echo $users['username'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> password:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="encrypted_password" class="required" value="<?php echo $users['password'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> confirmed_value:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="confirmed_value" class="required"  style="width:350px;" maxlength=25></div>
				</div>
				<?
				?>
				<div style="margin-top:20px;">
					<div class="edit_text1"> role:&nbsp;</div>
					<div class="edit_input1">
						<select id="role">
							<option <? if($users['role']=='user') {?> selected <? } ?> >user</option>
							<option <? if($users['role']=='admin') {?> selected <? } ?> > admin</option>
						</select>
					</div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> social_type:&nbsp;</div>
					<div class="edit_input1">
						<select id="social_type">
							<option <? if($users['social_type']=='email') { ?> selected <? } ?> >email</option>
							<option <? if($users['social_type']=='facebook') { ?> selected <? } ?>>facebook</option>
							<option <? if($users['social_type']=='twitter') { ?> selected <? } ?> >twitter</option>
							<option <? if($users['social_type']=='google') { ?> selected <? } ?>>google</option>
						</select>
					</div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> time_zone:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="time_zone" value="<?php echo $users['time_zone'];?>" class="required" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> push_enable:&nbsp;</div>
					<div class="edit_input1" style="height:40px;"><input type="checkbox" <? if($users['push_enable']=='true') { ?> checked <? } ?> class="required" id="push_enable"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> sound_enable:&nbsp;</div>
					<div class="edit_input1"  style="height:40px;"><input type="checkbox" <? if($users['sound_enable']=='true') { ?> checked <? } ?> value="<?php echo $users['sound_enable'];?>" id="sound_enable" class="required"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> theme_type:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="theme_type" class="required" value="<?php echo $users['theme_type'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> push_sound:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="push_sound" class="required" value="<?php echo $users['push_sound'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> user_status:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="user_status" class="required" value="<?php echo $users['user_status'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> auto_accept_friend:&nbsp;</div>
					<div class="edit_input1" style="height:40px;"><input type="checkbox" class="required" <?php if($users['auto_accept_friend']=='true') {?> checked <? } ?> id="auto_accept_friend"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> auto_notify_friend:&nbsp;</div>
					<div class="edit_input1" style="height:40px;"><input type="checkbox" class="required" <?php if($users['auto_notify_friend']=='true') {?> checked <? } ?> id="auto_notify_friend"></div>
				</div>				
				<div style="margin-top:20px;">
					<div class="edit_text1"> avatar:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="avatar" class="required" value="<?php echo $users['avatar'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;">
					<div class="edit_text1"> authentication_token:&nbsp;</div>
					<div class="edit_input1"><input type="text" id="authentication_token" class="required" value="<?php echo $users['authentication_token'];?>" style="width:350px;" maxlength=25></div>
				</div>
				<div style="margin-top:20px;text-align: right;width:81%;">
					<button class="btn btn-large btn-primary" onclick="onUsers_Edit_Submit(<?php echo $users['id'];?>);">Submit</button>
				</div>
			</form>
		</div>
 </div>   