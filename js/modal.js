function displayModal(selected)
{
    if ($(window).width() > 768) {
	
	var modal = document.getElementById("modalDiv");
	var mImg = document.getElementById("modalImage");
	
	modal.style.display = "block"; //make the modal sheet visible
	mImg.src = selected.src;
    }
}

function closeModal()
{
    var modal = document.getElementById("modalDiv");
    modal.style.display = "none";
}
