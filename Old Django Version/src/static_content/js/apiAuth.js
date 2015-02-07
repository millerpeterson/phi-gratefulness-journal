apiKey = '';

function getApiKey(username, password) {
	$.post('/accounts/getApiKey/',
			{ username: username,
			  password: password },
			function(data) {
				  var dataObj = safeJsonParse(data);
				  apiKey = dataObj.apiKey;
			});
			
}