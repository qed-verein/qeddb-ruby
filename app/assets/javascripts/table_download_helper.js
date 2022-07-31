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
		$(selector).hide();
}

function hideRow(item, row_selector, checked_is_hidden) {
	hide = $(item).is(':checked') == checked_is_hidden;
	rows = $(row_selector);
	let is_hidden = rows.parent().is('div');
	if (is_hidden !== hide) {
		if (hide) {
			rows.wrap('<div style="display: none"> </div>')
		} else {
			rows.unwrap('div')
		}
	}
}