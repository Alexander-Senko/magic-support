# frozen_string_literal: true

module Magic # :nodoc:
	module CoreExt # :nodoc:
		module Kernel
			# Some classes copy Kernel methods on initialization instead of
			# including Kernel itself. Thus, new methods should be defined
			# explicitly for them.
			MODULES = [ # classes/modules including Kernel methods
					::Kernel,
					(Delegator if defined? Delegator),
			].compact.freeze
		end

		module_function

		def kernel(&)
			Module.new(&).tap do |kernel|
				Kernel::MODULES.each { _1.include kernel }
			end
		end
	end
end
