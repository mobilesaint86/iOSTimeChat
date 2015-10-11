<!----------------------Pod Casts---------------->
<div class="container-fluid" style="margin-top:40px">
	<h1>Users Summary</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onAddUser();">Add Recorded User</a>
</div> <!-- /container -->

<div class="container-fluid" id="client_row" style="margin-top:40px;">
	<div id="client_row_div">
		<div id="content_2" class="container-fluid">
			<table class="main table tablesorter" id="sortTableExample" border="1" style="width: 100%;border-color:white;">
				<thead>
					<tr class="tr_height">
						<th class="header" style="width:4%;font-size:12px;">Id</th>
						<th class="header" style="width:4%;font-size:12px;">email</th>
						<th class="header" style="font-size:12px;">username</th>
						<th class="header" style="font-size:12px;">password</th>
						<th class="header" style="font-size:12px;">confirmed_value</th>
						<th class="header" style="font-size:12px;">sign_in_count</th>
						<th class="header" style="font-size:12px;">role</th>
						<th class="header" style="font-size:12px;">social_type</th>
						<th class="header" style="font-size:12px;">social_id</th>
						<th class="header" style="font-size:12px;">time_zone</th>
						<th class="header" style="font-size:12px;">friend_ids</th>
						<th class="header" style="font-size:12px;">invited_friend_ids</th>
						<th class="header" style="font-size:12px;">ignored_friend_ids</th>
						<th class="header" style="font-size:12px;">push_enable</th>
						<th class="header" style="font-size:12px;">sound_enable</th>
						<th class="header" style="font-size:12px;">theme_type</th>
						<th class="header" style="font-size:12px;">push_sound</th>
						<th class="header" style="font-size:12px;">user_status</th>
						<th class="header" style="font-size:12px;">auto_accept_friend</th>
						<th class="header" style="font-size:12px;">auto_notify_friend</th>
						<th class="header" style="font-size:12px;">avatar</th>
						<th class="header" style="font-size:12px;">authentication_token</th>
						<th class="header" style="font-size:12px;">updated_at</th>
						<th class="header" style="font-size:12px;">created_at</th>
						<th class="header" style="font-size:12px;">last_sign_in_at</th>
						<th class="header" style="font-size:12px;">current_sign_in_at</th>
						<th class="header" style="font-size:12px;">last_sign_in_ip</th>
						<th class="header" style="font-size:12px;">current_sign_in_ip</th>
						<th class="header" style="font-size:12px;">Action</th>
					</tr>
				</thead>
				<tbody>
					<?php
						for ($i=0;$i<count($users);$i++){
					?>
					<tr class="tr_height" id="<?php echo $users[$i]['id'];?>">
						<td><?php echo $users[$i]['id'];?></td>
						<td><?php echo $users[$i]['email'];?></td>
						<td><?php echo $users[$i]['username'];?></td>
						<td><?php echo $users[$i]['password'];?></td>
						<td><?php echo $users[$i]['confirmed_value'];?></td>
						<td><?php echo $users[$i]['sign_in_count'];?></td>
						<td><?php echo $users[$i]['role'];?></td>
						<td><?php echo $users[$i]['social_type'];?></td>
						<td><?php echo $users[$i]['social_id'];?></td>
						<td><?php echo $users[$i]['time_zone'];?></td>
						<td><?php echo $users[$i]['friend_ids'];?></td>
						<td><?php echo $users[$i]['invited_friend_ids'];?></td>
						<td><?php echo $users[$i]['ignored_friend_ids'];?></td>
						<td><?php echo $users[$i]['push_enable'];?></td>
						<td><?php echo $users[$i]['sound_enable'];?></td>
						<td><?php echo $users[$i]['theme_type'];?></td>
						<td><?php echo $users[$i]['push_sound'];?></td>
						<td><?php echo $users[$i]['user_status'];?></td>
						<td><?php echo $users[$i]['auto_accept_friend'];?></td>
						<td><?php echo $users[$i]['auto_notify_friend'];?></td>
						<td><?php echo $users[$i]['avatar'];?></td>
						<td><?php echo $users[$i]['authentication_token'];?></td>
						<td><?php echo $users[$i]['updated_at'];?></td>
						<td><?php echo $users[$i]['created_at'];?></td>
						<td><?php echo $users[$i]['last_sign_in_at'];?></td>
						<td><?php echo $users[$i]['current_sign_in_at'];?></td>
						<td><?php echo $users[$i]['last_sign_in_ip'];?></td>
						<td><?php echo $users[$i]['current_sign_in_ip'];?></td>
						<td>
							<div class="btn-group">
								<a class="btn btn-primary btn-small" href="#"><i class="icon-th icon-white"></i> Action</a>
								<a class="btn btn-primary btn-small dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
								<ul class="dropdown-menu">

								<li><a href="javascript: onUsersEdit(<?php echo $users[$i]['id'];?>);"><i class="icon-pencil icon-white"></i> Edit</a></li>
								<li><a href="javascript: onUsersDelete(<?php echo $users[$i]['id'];?>);"><i class="icon-trash icon-white"></i> Delete</a></li>
								</ul>
							</div>
						</td>
					</tr>
					<?php
						}
					?>
				</tbody>
			</table>
		</div>
	</div>
</div>    