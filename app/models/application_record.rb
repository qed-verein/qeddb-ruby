class ApplicationRecord < ActiveRecord::Base
	self.abstract_class = true
 	
 	# Diese Helferfunktion ignoriert bei der Formulareingabe eines assoziierten Models
 	# alle leeren Felder und löscht diese auch gegebenfalls aus der Datenbank
	def self.reject_blank_entries(attributes, keys = nil)
		keys = attributes.keys - ["id", "_destroy"] unless keys
		keys = [keys] unless keys.is_a?(Array)
		if attributes.slice(*keys).values.all? {|v| v.blank?}
			if attributes[:id].present?
				attributes.merge!({:_destroy => true}); false
			else true; end
		else p attributes; false; end
	end  
 
	# Helferfunktionen für lokalisierte Enumerations
	def self.human_enum_value(enum_symbol, key)
		return nil if key.nil?
		human_attribute_name(enum_symbol.to_s + "." + key)
	end 
 
	def self.human_enum_options(enum_symbol)
		send(enum_symbol).keys.map {|key|
			[human_attribute_name(enum_symbol.to_s.singularize + "." + key), key]}.to_h
	end
	
end
