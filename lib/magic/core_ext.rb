# frozen_string_literal: true

module Magic # :nodoc:
	module CoreExt # :nodoc:
		module_function

		def require_all scope = __FILE__
			scope
					.delete_suffix('.rb')
					.then { Pathname _1 }
					.glob('*.rb')
					.each { require _1 }
		end
	end

	CoreExt.require_all
end
