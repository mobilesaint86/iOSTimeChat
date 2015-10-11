<!----------------------Users---------------->
<div class="container" style="margin-top:40px">
	<h1>User Management</h1>
	<a class="btn btn-primary btn-large" style="margin-top:24px;"  onclick="onAddPodcast();">Add User</a>
</div> <!-- /container -->

        <div class="container" id="client_row" style="margin-top:40px;">
            <div id="client_row_div">
                        <div id="content_2" class="container">
                                    <table class="main table tablesorter" id="sortTableExample" border="1" style="width: 100%;border-color:white;">
                                        <thead>
                                            <tr class="tr_height">
                                              <th class="header">id</th>
                                              <th class="header">Username</th>
                                              <th class="header">Role</th>
                                              <th class="header"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                                for ($i=0;$i<count($users);$i++){
                                            ?>
                                            <tr class="tr_height" id="<?php echo $users[$i]['id'];?>">
                                                <td><?php echo $users[$i]['id'];?></td>
                                                <td><?php echo $users[$i]['username'];?></td>
                                                <td><?php if(isset($users[$i]['usergrade']) && $users[$i]['usergrade']==1)  echo "Administrator";
                                                	else echo "User"; ?></td>
                                                
                                                <td><div class="btn-group">
							  <a class="btn btn-primary btn-small" href="#"><i class="icon-th icon-white"></i> Action</a>
							  <a class="btn btn-primary btn-small dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
							  <ul class="dropdown-menu">
							    <li><a href="javascript: onUserChangePassword('<?php echo $users[$i]['username'];?>');"><i class="icon-lock icon-white"></i> Change Password</a></li>
							    <li><a href="javascript: onUserDelete(<?php echo $users[$i]['id'];?>);"><i class="icon-trash icon-white"></i> Delete</a></li>
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