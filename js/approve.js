function approveP(username, isApproved, num){
    let data = {"user": username, "approved": isApproved};
    $.ajax({
	type:"POST",
	url: "/approvalPicProcess",
	dataType:"json",
	data: JSON.stringify(data)
    }).done(function(json){
	if(json.success){
	    document.getElementById("userAppr" + num).remove();
	}	    
    });	
}


