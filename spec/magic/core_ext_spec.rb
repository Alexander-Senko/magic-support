# frozen_string_literal: true

module Magic
	RSpec.describe CoreExt do
		describe 'loading' do
			require 'magic/loader'

			subject { require 'magic/core_ext' }

			before { allow(Loader).to receive(:require).and_call_original }

			it 'loads all core extensions' do # rubocop:disable RSpec/MultipleExpectations
				is_expected.to be true # first load

				expect(Loader).to have_received(:require)
						.with(satisfy { _1.to_s =~ %r'magic/core_ext/\w+/\w+' })
						.at_least 1
			end
		end
	end
end
