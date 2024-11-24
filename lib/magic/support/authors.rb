# frozen_string_literal: true

require_relative '../../rubygems/author'

module Magic
	module Support
		class Author < Gem::Author # :nodoc:
			new(
					name:   'Alexander Senko',
					email:  'Alexander.Senko@gmail.com',
					github: 'Alexander-Senko',
			)
		end
	end
end
