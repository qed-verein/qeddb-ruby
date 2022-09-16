module GeneralHelpers
	def asciify(string)
		encoding_options = {:invalid => :replace, :undef => :replace, :replace => ''}

		string.gsub(/[äöüß]/i) do |match|
			{
				'Ä' => 'Ae',
				'Ö' => 'Oe',
				'Ü' => 'Ue',
				'ẞ' => 'Ss',
				'ä' => 'ae',
				'ö' => 'oe',
				'ü' => 'ue',
				'ß' => 'ss'
			}
		end.encode(Encoding.find('ASCII'), encoding_options)
	end

	def sole_element(iterable)
		first, *rest = iterable
		raise "None" if first.nil?
		raise "Multiple" unless rest.empty?
		first
	end
end