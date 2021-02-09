# Patch for mysql syntax (run before migrations)
Dir.glob("db/views/*.sql") {|file|
	File.write file, File.read(file).gsub("DATETIME('now')", "NOW()")}
