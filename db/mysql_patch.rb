# frozen_string_literal: true

# Patch for mysql syntax (run before migrations)
Dir.glob('db/views/*.sql') do |file|
  File.write file, File.read(file).gsub("DATETIME('now')", 'NOW()')
end
