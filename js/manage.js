function activateUser(username, activate, num){
    let data = {"user": username, "activate": activate};
    $.ajax({
	type:"POST",
	url: "/activateProcess",
	dataType:"json",
	data: JSON.stringify(data)
    }).done(function(json){
	
	actBtn = document.getElementById("activate" + num);
	if(json.userActive) {
	    actBtn.innerHTML = "Deactivate User";
	}
	else {
	    actBtn.innerHTML = "Activate User";
	}
	actBtn.setAttribute("onclick", "activateUser('" + username + "', " + !json.userActive + ", " + num + ")");
    });	
}

function delUser(username, num){
    let data = {"user": username};
    $.ajax({
	type:"POST",
	url: "/deleteUserProcess",
	dataType:"json",
	data: JSON.stringify(data)
    }).done(function(json){
	console.log(json);
	userRow = document.getElementById("manageUser" + num);
	console.log(userRow);
	if(json.success) {
	    userRow.remove();
	}
	else {

	}
    });	
}
