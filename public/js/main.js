
function goto(app) {

	location.href = "/dashboard/app/" + app ;
}

$(function() {

	
	$(".griditem").mouseover( function(e) {
		 $(this).attr("class","griditemhover"); 
	});
	$(".griditem").mouseout( function(e) {
		 $(this).attr("class","griditem"); 
	});

	
});

