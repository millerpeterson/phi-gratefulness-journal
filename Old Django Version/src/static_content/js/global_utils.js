function safeJsonParse(jsonStr)
{
    var parsedObj;
    var safeJsonStr = jsonStr.replace(/</g, "&lt;");
    safeJsonStr = safeJsonStr.replace(/>/g, "&gt;");    
    
    try
    {
        parsedObj = JSON.parse(safeJsonStr);
    }
    catch (Error)
    {
        parsedObj = null;
    }
    return parsedObj;
}

// Sets cursor position inside a textarea.
// Ex: $("#input").focus(function() {
//		$(this).setCursorPosition(4);
// }
new function($) {
	  $.fn.setCursorPosition = function(pos) {
	    if ($(this).get(0).setSelectionRange) {
	      $(this).get(0).setSelectionRange(pos, pos);
	    } else if ($(this).get(0).createTextRange) {
	      var range = $(this).get(0).createTextRange();
	      range.collapse(true);
	      range.moveEnd('character', pos);
	      range.moveStart('character', pos);
	      range.select();
	    }
	  }
	}(jQuery);