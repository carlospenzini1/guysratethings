function preview() {
    
    let imgName ="frame"  +  event.target.name.substring(5);
    let img = document.getElementById(imgName);
    img.style.display = "inline";
    img.src = URL.createObjectURL(event.target.files[0]);
}
function pPreview() {
    frame.src = URL.createObjectURL(event.target.files[0]);
}


function follow(username, follow, follower ){
    let data = {"user":username, "follow": follow, "follower": follower };
    $.ajax({
	type:"POST",
	url: "/followerProcess",
	dataType:"json",
	data: JSON.stringify(data)
    }).done(function(json){
	if(json.isFollowing){
	    document.getElementById("fol").innerHTML = json.fCount + " Followers" ;
	    document.getElementById("fB").innerHTML= "Unfollow";
	    $("#fB").attr("onclick", "follow('" + username + "', false, '" + follower + "')");
 	}
	else
	{
	    document.getElementById("fol").innerHTML =  json.fCount + " Followers";
	    document.getElementById("fB").innerHTML= "Follow";
	    $("#fB").attr("onclick", "follow('" + username + "', true, '" + follower + "')");
	}
    });

}

function hideImages(){
    let imgs = document.getElementsByTagName("img");
    var elems  = [];
    for(var i = 0; i < imgs.length; i++)
    {
	if(imgs[i].id.indexOf('frame') == 0)
	{
            elems.push(imgs[i]);
	}
    }
    for(var i = 0; i < elems.length; i++)
    {
	if(elems[i].src == "https://guysratethings.com/none")
	{
	    elems[i].style.display = "none";
	}
    }  
}

function addField()
{
    var list = document.getElementsByTagName("input");
    var eles = [];
    for(var i = 0; i < list.length; i++)
    {
	if(list[i].name.indexOf('input') == 0)
	{
            eles.push(list[i]);
	}
    }

    var numb = eles[eles.length-1].name.substring(5);
    var next = parseInt(numb)+1;
    var  div = document.getElementById("items");

    var listItem = '<div class="row pt-3 mb-2" id="row-item'+next+'"><div class="col-lg-6 mb-2 col-justify-content-center"><div class="row"><div class="col-sm-10"><div class="row"><div class="col-1"><h2 id="number'+next+'">'+next+'.</h2></div><div class="col-11"><h2><input class="form-control" type="text" name = "item'+next+'_title" id ="item'+next+'_title " placeholder="Item" required></h2></div></div></div><div class="col-sm-2"><button type="button" onclick="deleteItem(this)" id="delete'+next+'"  class="btn-list btn btn-primary mb-1">delete</button></div></div><div class="row"><div class="col"><input class="form-control" type="file" name="input'+next+'" id="input'+next+'" accept=".jpg,.jpeg,.gif,.png" onchange="preview()">	<img name="frame'+next+'" id="frame'+next+'" src="none" class="gimg pt-2 " /></div></div></div><div class="col-lg-6"><h4> <textarea class="form-control" name="textarea'+next+'"  id="textarea'+next+'" rows="3" placeholder="Enter Description Here"></textarea> </h4></div></div>';
    div.insertAdjacentHTML("beforeend",listItem);
    const param = document.querySelector("#item_count");
    param.innerHTML = next;
    
    hideImages();
}


function deleteItem(btn)
{
    var list = document.getElementsByTagName("input");
    var eles = [];
    for(var i = 0; i < list.length; i++)
    {
	if(list[i].name.indexOf('input') == 0)
	{
            eles.push(list[i]);
	}
    }

    
    var next = eles.length;

    if(next > 3)
    {
	
	var num = parseInt(btn.id.substring(6));
        document.getElementById("row-item" + num).remove();

	num++;
	
	var elem  = document.getElementById("row-item" + num); 

        while(elem)
        {

	    
	    var jackSulkes = $("#number" + num );

	    jackSulkes.html((num - 1) + ". "); 
	    jackSulkes.attr("id", "number" + (num - 1));

	    
	    var title = $("#item" + num + "_title");   
	    title.attr("id", "item" + (num - 1) + "_title");
	    title.attr("name", "item" + (num - 1) + "_title");
	    
	    var deletebtn = $("#delete" + num)
	    deletebtn.attr("id", "delete" + (num - 1));

	    
	    var inputElem = $("#input" + num);
	    inputElem.attr("id", "input" + (num - 1));
	    inputElem.attr("name", "input" + (num - 1));

	    var frame = $("#frame" + num);
	    frame.attr("id", "frame" + (num - 1));
	    frame.attr("name", "frame" + (num - 1));

	    var textArea = $("#textarea" + num);
	    textArea.attr("id", "textarea" + (num - 1));
	    textArea.attr("name", "textarea" + (num - 1));

	    var rowNumby = $("#row-item" + num);
	    rowNumby.attr("id", "row-item" + (num-1));

	    
	    num++;

	    
	    elem = document.getElementById("row-item" + num);
        }
    
	const param = document.querySelector("#item_count");
	param.innerHTML = next - 1;
   
    }

    
}

