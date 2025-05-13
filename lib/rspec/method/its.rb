# frozen_string_literal: true

module RSpec
	module Method # :nodoc:
		# Adds the `its_result` to RSpec method example groups.
		# Included by default.
		module Its
			def its_result(*args, &) = its(args, &)
		end

		ExampleGroup::ClassMethods.include Its
	end
end
