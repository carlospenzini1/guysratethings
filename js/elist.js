function vote(right, left, score, listU ){
     let data = {"right":right, "left": left, "score": score, "listU": listU };
     $.ajax({
         type:"POST",
         url: "/voteProcess",
         dataType:"json",
         data: JSON.stringify(data)
     }).done(function(json){
	 document.getElementById("leftImg").src = json.left.itemimg.url;
	 document.getElementById("rightImg").src = json.right.itemimg.url;
	 document.getElementById("rightImg").alt = json.right.title;
	 document.getElementById("leftImg").alt = json.left.title;
	 document.getElementById("rightT").innerHTML = json.right.title;
	 document.getElementById("leftT").innerHTML = json.left.title;
	 document.getElementById("mid").setAttribute("onClick","vote("+json.right.id+","+json.left.id +","+0.5 +"," +json.right.list_id + ")");
	 document.getElementById("left").setAttribute("onClick","vote("+json.right.id+","+json.left.id +","+0 +"," +json.right.list_id + ")");
	 document.getElementById("right").setAttribute("onClick","vote("+json.right.id+","+json.left.id +","+1 +"," +json.right.list_id + ")");
     });
 }
