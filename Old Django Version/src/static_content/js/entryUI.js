function Entry(jqObj) {
	
	console.debug("Entry()");
	
	// Reference to jQuery object for the class="entry"
	// DOM object this Entry object is linked to.
	this.jqObj = jqObj;
	
	// Switch to viewMode if it is set in DOM input property.
	initViewMode = this.getInputProp("viewMode");
	if (initViewMode != "")
		this.setViewMode(initViewMode);
}

Entry.prototype.getInputProp = function(propName) {
	return this.jqObj.find("input[name='" + propName + "']").val();
}

Entry.prototype.setInputProp = function(propName, newVal) {
	this.jqObj.find("input[name='" + propName + "']").val(newVal);
}

Entry.prototype.getEntryId = function() {
	console.debug("getEntryId");
	return this.getInputProp("entryId");
}

Entry.prototype.setEntryId = function(newVal) {
	this.setInputProp("entryId", newVal);
}

Entry.prototype.getEntryBody = function() {
	return this.jqObj.find(".bodyEditTextarea:first").val();
}

Entry.prototype.updateEntryBody = function() {
	this.jqObj.find(".bodyEditTextarea:first").val();
	
}

Entry.prototype.setDate = function(dateHtml) {
	this.jqObj.find(".dateWritten").html(dateHtml);
}

Entry.prototype.getDate = function() {
	return this.jqObj.find(".dateWritten").html();
}

Entry.prototype.setViewMode = function(mode) {
	console.debug("setViewMode " + mode);
	this.setInputProp("viewMode", mode);	
	if (mode == "view") {
		this.jqObj.find(".bodyView").show();
		this.jqObj.find(".bodyEdit").hide();		
	} else if (mode == "edit") {		
		this.jqObj.find(".bodyView").hide();
		this.jqObj.find(".bodyEdit").show();
		this.jqObj.find(".body").focus();
	}
}

Entry.prototype.save = function() {
	console.debug("save " + this.getEntryId());
	var saveCallback = jQuery.proxy(this.saveCompleted, this);
	$.post('/journal/createOrUpdate/',
		{ 	body: this.getEntryBody(),
			entryId: this.getEntryId(),
			key: apiKey },
		saveCallback);	
}

Entry.prototype.saveCompleted = function(data) {	  
	var dataObj = safeJsonParse(data);
	console.debug("saveCompleted - updatedId = " + dataObj.updatedId);
	this.setEntryId(dataObj.updatedId);
	this.updateBody();
	// Invoke save complete callback if it has been set.
	if ("onSaveComplete" in this)
		this.onSaveComplete(this);	
}

Entry.prototype.updateBody = function() {
	console.debug("updateBody " + this.getEntryId());
	var updateCallback = jQuery.proxy(this.bodyUpdated, this);
	$.post('/journal/renderBody/',
			{ 	entryId: this.getEntryId(),
			  	key: apiKey }, 
			updateCallback);
				
}

Entry.prototype.bodyUpdated = function(newBody) {
	console.debug("bodyUpdated - newBody = " + newBody);
	this.jqObj.find(".bodyView").html(newBody);
	this.setViewMode("view");
}

var entries = new Array();

$(document).ready(function() {
	
	// Create Entry objects linked to every class="entry" DOM
	// element already in the page.	
	$(".entry").each(function() {
		var e = new Entry($(this));
		entries.push(e);
	});
	
});