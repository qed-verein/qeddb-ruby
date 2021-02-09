function downloadTable(selector) {
	$(selector).first().table2csv({"excludeColumns": "td[display='none'], td:first-child, th:first-child"});
}