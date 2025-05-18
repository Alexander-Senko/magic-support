# frozen_string_literal: true

require 'active_support/concern'
require 'magic/core_ext/kernel/optional'

module RSpec # :nodoc:
	module Method
		REFERENCE = {
				scope: /[.#]/, # class/instance
				name:  /\S+/,  # may consist of non-word characters
		}
				.map { |name, pattern| "(?<#{name}>#{pattern})" }
				.join
				.then { /(?:^|\s)#{_1}(?:$|\s)?/ } # may be surrounded by some text

		# @api public
		# Container module for method specs.
		module ExampleGroup
			extend ActiveSupport::Concern

			included do
				metadata[:type] ||= :method

				setup_method_context
			end

			class_methods do
				def subject(name = nil, &)
					if name
						alias_method :__subject__, let(name, &)

						self::NamedSubjectPreventSuper.__send__ :define_method, name do
							raise NotImplementedError, '`super` in named subjects is not supported'
						end
					else
						let :__subject__, &
					end
				end

				private

				def setup_method_context
					description.match(REFERENCE) in { scope:, name: } or
							raise ArgumentError, "'#{description}' doesn't look like a method reference"

					backup_subject

					let :receiver do
						case [ scope, __subject__ ]
						in '#', receiver
							receiver
						in '.', Module => receiver
							receiver
						in '.', receiver
							receiver.class
						end
					end

					let(:method_name) { name.to_sym }
				end

				def backup_subject
					subject_method = instance_method :subject

					while subject_method.owner.then { not _1.respond_to? :metadata or _1.metadata[:method] }
						subject_method = subject_method.super_method or break
					end

					if subject_method
						let(:__subject__) { subject_method.bind_call self }
					else
						let(:__subject__) { method(:subject).super_method[] }
					end
				end
			end

			def subject
				receiver.method method_name
			rescue NameError => error
				raise unless
						(receiver.is_a? error.receiver rescue false)

				warn "Testing #{error}"

				-> *args { receiver.send method_name, *args }
			end
		end
	end

	require_relative 'method/its' if defined? Its

	shared_context :method, description: Method::REFERENCE do
		include Method::ExampleGroup

		shared_context :delegated do |to:, with: nil|
			before do
				allow(to).to receive(method_name)
						.optional { _1.with *with if with }
						.and_call_original
			end

			it "delegates to #{to.inspect}" do
				subject[*with]

				expect(to).to have_received(method_name)
						.once
			end
		end
	end

	shared_context :nested_method, full_description: /(.*#{Method::REFERENCE}){2,}/ do
		next unless metadata[:description].match? Method::REFERENCE

		setup_method_context
	end

	configure do
		_1.backtrace_exclusion_patterns << %r'/lib/rspec/method'
	end
end
