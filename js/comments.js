function comment(username, ifAdmin)
{

    let comment = $("#commentText").val();
    if(comment === "")
	return;
    let path =  window.location.pathname.split("/");
    let uidList = path[path.length - 1]; 
    let data = {"commenter": username, "listid": uidList, "commentText": comment};

    $.ajax({
	type:"POST",
	url: "/commentAction",
	dataType:"json",
	data: JSON.stringify(data)
    }).done(function(json){
	let main = document.getElementById("commentSection");
	let commHTML = "";
	json.allComments.forEach(function(comm, index){
	    var dateNow = new Date(comm.created_at).toLocaleString();
	    commHTML = commHTML +  '<div class="row">\
               <div class="col-md-1">\
               <img src= '+json.profileImgs[index]+' alt="" class="user-img rounded-circle mr-2 ">\
               </div>\
               <div class="col-md-9">\
               <h6><a class="smpLink" href="/profile/'+json.allUsers[index].username+'">@'+json.allUsers[index].username+'</a>\
               <small id="date'+index+'" class="text-muted mx-1"> - '+dateNow+'</small>';
	  
	    if($("#likeBtn").prop('disabled'))
		commHTML = commHTML + '<input class="mx-2" id="likeBTN" disabled type="image" width="25" height="18.29" src="/imgs/whiteBump.png">';
	    else if(json.boolLikes[index])
		    commHTML = commHTML + '<input class="mx-2" id="likeBtn'+index+'" src="/imgs/whiteBump.png" width="25" height="18.29" type="image" onmouseout="cmtLikeFadeOut('+index+')" onmouseover="cmtLikeFadeIt('+index+')" onclick="cmtLike(true, '+index+', '+"'" + json.allUsers[index].username+ "'" +' )">';
	    else
		commHTML = commHTML + '<input class="mx-2" id="likeBtn'+index+'" src="/imgs/purpleBump.png" width="25" height="18.29" type="image" onclick="cmtLike(false, '+index+', '+"'" + json.allUsers[index].username+ "'" +' )">';
		
	    commHTML = commHTML + '<small id="cmtLikeDisplay'+index+'"class="text-muted">'+json.numLikes[index]+' likes </small>';
	    if(ifAdmin || username === json.allUsers[index].username) //add if user owns the comment
		commHTML = commHTML + '<button type="button" id="del'+index+'">Delete</button>';

	    commHTML = commHTML + '</h6>\
            <p id="text'+index+'">'+comm.text+'</p>\
            </div>\
            </div>'
	});
	$("#commentText").val('');
	$("#commentSection").empty();
	main.insertAdjacentHTML("afterbegin", commHTML);
    });
}

function loadComments(offset, limit, ifAdmin)
{
    let path =  window.location.pathname.split("/");
    let uidList = path[path.length - 1];
    let comment = $("#commentText").val();
    let username = $("#userImageCmt").prop("href");
    username = $("#userImageCmt");
    username = username.prop("href");
    if(username != undefined)
    {
	username = username.substring(35);
    }
    
    let data = {"listid": uidList, "offset": offset, "limit": limit, "theUser": username};
    $.ajax({
	type:"POST",
	url: "/load_comments",
	dataType:"json",
	data: JSON.stringify(data)
    }).done(function(json){
	let main = document.getElementById("commentSection");
	let commHTML = "";
	json.allComments.forEach(function(comm, index){
	    console.log(comm.created_at);
	    var dateNow = new Date(comm.created_at).toLocaleString();
	    commHTML = commHTML +  '<div class="row">\
               <div class="col-md-1">\
               <img src= '+json.profileImgs[index]+' alt="" class="user-img rounded-circle mr-2 ">\
               </div>\
               <div class="col-md-9">\
               <h6><a class="smpLink" href="/profile/'+json.allUsers[index].username+'">@'+json.allUsers[index].username+'</a>\
               <small id="date'+index+'" class="text-muted mx-1"> - '+dateNow+'</small>';
	  
	    if($("#likeBtn").prop('disabled'))
		commHTML = commHTML + '<input class="mx-2" id="likeBTN" disabled type="image" width="25" height="18.29" src="/imgs/whiteBump.png">';
	    else if(json.boolLikes[index])
		    commHTML = commHTML + '<input class="mx-2" id="likeBtn'+index+'" src="/imgs/whiteBump.png" width="25" height="18.29" type="image" onmouseout="cmtLikeFadeOut('+index+')" onmouseover="cmtLikeFadeIt('+index+')" onclick="cmtLike(true, '+index+', '+"'" + json.allUsers[index].username+ "'" +' )">';
	    else
		commHTML = commHTML + '<input class="mx-2" id="likeBtn'+index+'" src="/imgs/purpleBump.png" width="25" height="18.29" type="image" onclick="cmtLike(false, '+index+', '+"'" + json.allUsers[index].username+ "'" +' )">';
		
	    commHTML = commHTML + '<small id="cmtLikeDisplay'+index+'"class="text-muted">'+json.numLikes[index]+' likes </small>';

	    if(ifAdmin || username === json.allUsers[index].username) //add if user owns the comment
		commHTML = commHTML + '<button type="button" class="btn btn-primary delBtn delThin" id="del'+index+'">X</button>';
            
	    commHTML = commHTML + '</h6>\
            <p id="text'+index+'">'+comm.text+'</p>\
            </div>\
            </div>'
	});
	
	//$("#commentSection").empty();
	main.insertAdjacentHTML("beforeend", commHTML);
    });

}
