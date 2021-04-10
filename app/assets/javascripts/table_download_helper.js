function downloadTable(selector) {
	$(selector).first().table2csv({"excludeColumns": "td[display='none'], td:first-child, th:first-child"});
}

function updateVisibility(item) {
	var regex = /show_([a-z_]+)/;
	match = item.id.match(regex);
	if(!match) return;
	selector = '.' + match[1];
	checked = $(item).is(':checked');
	if(checked)
		$(selector).show();
	else
		$(selector).hide();}