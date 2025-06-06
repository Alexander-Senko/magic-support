# frozen_string_literal: true

module Magic
	RSpec.describe Kernel do
		subject { Object.new }

		let(:object) { Object.new }

		describe '#optional' do
			require 'magic/core_ext/kernel/optional'

			let(:block) { -> receiver { condition and object } }

			context 'when the block returns a truthy value' do
				let(:condition) { true }

				it 'returns the value' do
					expect(subject.(&block)).to be object
				end
			end

			context 'when the block returns nil' do
				let(:condition) { nil }

				it 'returns self' do
					expect(subject.(&block)).to be receiver
				end
			end

			context 'when the block returns false' do
				let(:condition) { false }

				it 'returns self' do
					expect(subject.(&block)).to be receiver
				end
			end
		end
	end

	# Every method defined on `Kernel` should be defined on some other
	# classes as well.
	# See `Magic::CoreExt::Kernel::MODULES` for further details.
	RSpec.shared_context full_description: /^Kernel#/ do
		require 'magic/core_ext/kernel/utils'
		require 'active_support/core_ext/enumerable'

		let(:kernel_method) { Kernel.instance_method method_name }

		for including_kernel in CoreExt::Kernel::MODULES.without Kernel do
			describe including_kernel do
				it 'has the same method' do
					expect(described_class.instance_method method_name).to eq kernel_method
				end
			end
		end
	end
end
