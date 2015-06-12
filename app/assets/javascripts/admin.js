

function moveup( a ) {
	
	var tr 		= $(a).parent().parent();
	var trprev 	= tr.prev();
	trprev.before( tr );
		
}

function movedown( a ) {

	var tr 		= $(a).parent().parent();
	var trnext 	= tr.next();
	trnext.after( tr );

}

function saveseq() {

	var trs = $("#tblapp tr");
	var seq_hash = {};

	for ( i = 1 ; i < trs.length - 1 ; i++ ) {
		var jqtr = $( trs[i] );
		var appid = parseInt( $( jqtr.find( "td" )[0] ).html() );
		seq_hash[appid] = i ;
	}

	var params = {
		data : JSON.stringify(seq_hash)
	}
	
	var jqxhr = $.post( "/admin/saveseq", params , function( response ) {
		
		if ( response["status"] == 0 ) {
			$.toaster({ priority : 'success', title : 'Apps', message : 'Listing order saved'});
		} else {
			$.toaster({ priority : 'warning', title : 'Apps', message : 'Oops, something went wrong!'});
			console.log( response["statusmsg"] );

		}
	}, 'json');

}


$(function() {


});
