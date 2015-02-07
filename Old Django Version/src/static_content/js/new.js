$(document).ready(function() {
	// User should already have gone through session authentication,
	// so we don't need to supply username / password to get api key.
	getApiKey('', '');
	setupSaveButton();	
});

var newEntry;

function setupSaveButton() {
	
	newEntry = entries[0];
	
	$("#saveButton").click(function() {
		newEntry.save();
		return false;
	});

	var now = new Date();
	newEntry.setDate(now.format("longDate"));
	newEntry.onSaveComplete = newEntrySaved;

}

function newEntrySaved(entry) {
	console.debug("newEntrySaved()");
	$("#saveButton").hide();
	var entryId = newEntry.getEntryId();
	getRelativeEntry(entryId, 30, 7, 'One Month Ago', addRelativeEntryCallback);
	getRelativeEntry(entryId, 60, 14, 'Two Months Ago', addRelativeEntryCallback);
	getRelativeEntry(entryId, 120, 14, 'Six Months Ago', addRelativeEntryCallback);
	getRelativeEntry(entryId, 365, 30, 'One Year Ago', addRelativeEntryCallback);
}

function getRelativeEntry(refEntryId, daysAgo, tolerance, caption, callback) {
	console.debug("getRelativeEntry: refEntryId " + refEntryId +
			" daysAgo: " + daysAgo + " tolerance " + tolerance);
	$.post('/journal/getRelativeEntryId/',
			{ refEntryId: refEntryId,
			  relDays: daysAgo,			  
			  tolerance: tolerance,
			  key: apiKey },
			  function(data) {
				  var dataObj = safeJsonParse(data);
				  dataObj.caption = caption;
				  callback(dataObj);
			  });
			
}

function addRelativeEntryCallback(dataObj) {	  
	  console.debug("caption: " + dataObj.cation + " relative entryId : " + dataObj.entryId);
	  if (dataObj.entryId != -1)
		  addEntryToContainer(dataObj.entryId, dataObj.caption, $("#entryContainer"));
}

function addEntryToContainer(entryId, caption, container) {
	console.debug("addEntryToContainer " + entryId + " " + container);
	$.post('/journal/renderUI/',
			{ entryId: entryId,
			  caption: caption,
			  key: apiKey },
			function(entryHtml) {
				container.append(entryHtml);
				var addedJqObj = $(".entry:has(input[name='entryId'][value='" + entryId + "'])");
				entries.push(new Entry(addedJqObj));				
			});
}