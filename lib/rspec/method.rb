# frozen_string_literal: true

require 'active_support/concern'

module RSpec # :nodoc:
	module Method
		REFERENCE = {
				scope: /[.#]/, # class/instance
				name:  /\S+/,  # may consist of non-word characters
		}
				.map { |name, pattern| "(?<#{name}>#{pattern})" }
				.join
				.then { /(?:^|\s)#{_1}(?:$|\s)/ } # may be surrounded by some text

		# @api public
		# Container module for method specs.
		module ExampleGroup
			extend ActiveSupport::Concern

			included do
				metadata[:type] ||= :method

				description.match(REFERENCE) in { scope:, name: } or
						raise ArgumentError, "'#{description}' doesn't look like a method reference"

				subject_method = instance_method :subject

				while subject_method.owner.then { not _1.respond_to? :metadata or _1.metadata[:method] }
					subject_method = subject_method.super_method or break
				end

				define_method :subject do
					receiver =
							case [ scope, subject_method&.bind_call(self) || super() ]
							in '#', receiver
								receiver
							in '.', Module => receiver
								receiver
							in '.', receiver
								receiver.class
							end

					receiver.method name
				rescue NameError
					# TODO: emit a warning

					-> *args { receiver.send name, *args }
				end

				let(:method_name) { name.to_sym }
			end

			class_methods do
				def subject(&)
					prepend Module.new {
						define_method(:subject) { super().unbind.bind instance_eval(&) }
					}
				end

				next unless defined? RSpec::Its

				def its_result(*args, &) = its(args, &)
			end
		end
	end

	shared_context :method, description: Method::REFERENCE do
		include Method::ExampleGroup
	end

	configure do
		_1.backtrace_exclusion_patterns << %r'/lib/rspec/method'
	end
end
