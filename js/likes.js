function listLike(areLiking, username)
{
    let path = window.location.pathname.split("/");
    let uidList = path[path.length - 1];
    let happyMan = path[path.length - 2];
    
    
    let likeData = {"happyUser": happyMan, "listid": uidList, "likeAction":areLiking, "liker":username};

    $.ajax({
	type:"POST",
	url:"/listLikeAction",
	dataType:"json",
	data: JSON.stringify(likeData)
    }).done(function(json){
	var likeBtn = $("#likeBtn");
	if(areLiking)
	{
	    likeBtn.attr("onclick", "listLike("+!areLiking+",'"+username+"')");
	    likeBtn.attr("src", "/imgs/purpleBump.png");
	    likeBtn.attr("onmouseout", "");
	    likeBtn.attr("onmouseover", "");
	}
	else
	{
	    likeBtn.attr("onclick", "listLike(true, '"+username+"')");
	    likeBtn.attr("src", "/imgs/whiteBump.png");
	    likeBtn.attr("onmouseout", "listLikeFadeOut()");
	    likeBtn.attr("onmouseover", "listLikeFadeIt()");
	}

	var likeArea = $("#likeDisplay");
	likeArea.html(json.likeNum + " likes");
    });
}

function listLikeFadeIt()
{
    $("#likeBtn").attr("src", "/imgs/fadedBump.png");
}

function listLikeFadeOut()
{
    $("#likeBtn").attr("src", "/imgs/whiteBump.png");
}

function cmtLike(areLiking, cmtID, cmtUser)
{
    let date = $("#date" + cmtID).html();
    date = date.substring(3, date.length);
    let utcDate = new Date(date)
    console.log(utcDate);
//	.toUTCString();
    console.log(utcDate.toUTCString());
    let path = window.location.pathname.split("/");
    let uidList = path[path.length - 1];
    
    let cmtText = $("#text"+cmtID).html();
    let username = $("#userImageCmt")
    username = username.prop("href");
    username = username.substring(35);
            
    let likeData = {"happyUser": cmtUser, "listid": uidList, "likeAction": areLiking, "liker": username, "text": cmtText};
    
    $.ajax({
	type:"POST",
	url:"/cmtLikeAction",
	dataType:"json",
	data: JSON.stringify(likeData)
    }).done(function(json){
	var likeBtn = $("#likeBtn" + cmtID);
	if(areLiking)
	{
	    likeBtn.attr("onclick", "cmtLike("+!areLiking+", '"+cmtID+"','"+cmtUser+"')");
	    likeBtn.attr("src", "/imgs/purpleBump.png");
	    likeBtn.attr("onmouseout", "");
	    likeBtn.attr("onmouseover", "");
	}
	else
	{
	    likeBtn.attr("onclick", "cmtLike(true, '"+cmtID+"','"+cmtUser+"')");
	    likeBtn.attr("src", "/imgs/whiteBump.png");
	    likeBtn.attr("onmouseout", "cmtLikeFadeOut("+cmtID+")");
	    likeBtn.attr("onmouseover", "cmtLikeFadeIt("+cmtID+")");
	}

	$("#cmtLikeDisplay"+cmtID).html(json.likeNum + " likes");
	
    });
    
}

function cmtLikeFadeIt(cmtID)
{
    
    $("#likeBtn"+cmtID).attr("src", "/imgs/fadedBump.png");
}

function cmtLikeFadeOut(cmtID)
{
     $("#likeBtn"+cmtID).attr("src", "/imgs/whiteBump.png");
}
