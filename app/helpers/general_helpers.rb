module GeneralHelpers
	def asciify(string)
		replacements = {
			'Ä' => 'Ae',
			'Ö' => 'Oe',
			'Ü' => 'Ue',
			'ẞ' => 'Ss',
			'ä' => 'ae',
			'ö' => 'oe',
			'ü' => 'ue',
			'ß' => 'ss'
		}
		I18n.transliterate(string).gsub(/[^A-Za-z0-9 -]/) do |match|
			replacements[match] || ''
		end
	end

	def sole_element(iterable)
		first, *rest = iterable
		raise "None" if first.nil?
		raise "Multiple" unless rest.empty?
		first
	end
end
