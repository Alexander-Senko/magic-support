# frozen_string_literal: true

require_relative 'utils'

Magic::CoreExt.kernel do
	# Yields self to the block and returns the result of the block if it’s
	# truthy, and self otherwise.
	#
	#   rand(6)                              # returns 0–5
	#     .optional { it + 1 if one_based? } # returns 1–6 if 1-based, or
	#                                        # the original 0–5 otherwise
	#
	# It can be considered as a conditional +then+.
	#
	# Good usage for +optional+ is value piping in method chains with
	# conditional processing:
	#
	#   @people = Person
	#     .optional { it.where created_at: (1.hour.ago...) if new? }
	#     .optional { anonymize it if gdpr? }
	#     .optional { try :decorate }
	#
	def optional
		tap do
			result = yield(self) or
					next

			break result
		end
	end
end
