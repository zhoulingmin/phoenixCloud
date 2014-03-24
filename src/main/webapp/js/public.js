
$(document).ready(function () {

	//$(".left_main h3:first").addClass("box_line1");
	$(".left_main ul:not(:first)").hide();
	$(".left_main h3").click(function () {
		$(this).next("ul").slideToggle("slow")
		.siblings("ul:visible").slideUp("slow");
		//$(this).toggleClass("box_line1");
		//$(this).siblings("h3").removeClass("box_line1");
	});
});

//隔行换色
	$(function () {
		$(".list_table tbody tr").mouseover(function () { $(this).addClass("over"); }).mouseout(function () { $(this).removeClass("over"); });
		$(".list_table tbody tr:even").addClass("alt");
	}
    );
