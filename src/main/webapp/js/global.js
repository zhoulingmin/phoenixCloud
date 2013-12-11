
function setActiveClass(which) {
	//window.console.log(JSON.stringify(which));
	$.each($(which).parent().children(),function(iter){$(this).removeClass("active");});
	$(which).addClass("active");
}

function newWindow(url, id) {
	Popup = window.open(url,id,'toolbar=no,location=no,status=yes,menubar=no, scrollbars=yes,resizable=yes,width=750,height=600,left=200,top=0');
}