# frozen_string_literal: true

require 'rspec/method'

RSpec.describe RSpec::Method do
	describe 'constants' do
		it { expect(described_class::REFERENCE).to be_a Regexp }
	end

	describe ':method context' do
		subject { Object.new }

		describe '.new' do
			it { expect(method_name).to eq :new }

			its_result { is_expected.to be_instance_of Object }
		end

		describe '#to_s' do
			it { expect(method_name).to eq :to_s }

			its_result { is_expected.to be_a String }
			its_result { is_expected.to match /\A#<Object:0x\h+>\Z/ }

			context 'with an overridden subject' do
				subject { :new_subject }

				# NOTE: it’s still `Object#to_s`, not `Symbol#to_s`
				its_result { is_expected.to match /\A#<Symbol:0x\h+>\Z/ }
			end
		end

		context 'when private' do
			describe '#puts' do
				it { expect(method_name).to eq :puts }

				its_result { is_expected.to be_nil }
			end
		end

		context 'when missing' do
			describe '#undefined_method' do
				it { expect(method_name).to eq :undefined_method }

				it { expect { subject[] }.to raise_error NoMethodError }
			end
		end

		context 'with a class' do
			subject { Object }

			shared_examples '.new' do
				its_result { is_expected.to be_instance_of Object }
			end

			describe('.new') { it_behaves_like '.new' }

			describe('#new') { it_behaves_like '.new' }
		end

		context 'with a module' do
			subject { Kernel }

			shared_examples '.pp' do
				its_result                                  { is_expected.to be_nil }
				its_result(argument = Object.new)           { is_expected.to eq argument }
				its(arguments = 2.times.map { Object.new }) { is_expected.to eq arguments }
			end

			describe('.pp') { it_behaves_like '.pp' }

			describe('#pp') { it_behaves_like '.pp' }
		end

		describe ':delegated context' do
			subject { self }

			MyModule ||= Module.new { # rubocop:disable RSpec/LeakyConstantDeclaration
				def self.my_method(*args) = args
			}

			def my_method(...) = MyModule.my_method(...)

			describe '#my_method' do
				it_behaves_like :delegated, to: MyModule

				it_behaves_like :delegated, to: MyModule,
						with: Object.new
				it_behaves_like :delegated, to: MyModule,
						with: 2.times.map { Object.new }
			end
		end
	end
end
