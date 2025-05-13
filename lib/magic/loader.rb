# frozen_string_literal: true

require 'pathname'

module Magic # :nodoc:
	module Loader # :nodoc:
		module_function

		def require_all scope = caller_locations[0].path
			Pathname(scope)
					.sub_ext('')
					.glob('*.rb')
					.each { require _1 }
		end
	end
end
