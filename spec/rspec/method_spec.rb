# frozen_string_literal: true

require 'rspec/method'

RSpec.describe RSpec::Method do
	describe 'constants' do
		it { expect(described_class::REFERENCE).to be_a Regexp }
	end

	describe ':method context' do
		context 'with an implicit subject' do
			describe '.to_s' do
				it { expect(receiver).to eq described_class }
				it { expect(method_name).to eq :to_s }

				its_result { is_expected.to be_a String }
				its_result { is_expected.to eq described_class.name }
			end
		end

		context 'with an explicit subject' do
			subject { object }

			let(:object) { Object.new }

			describe '.new' do
				it { expect(receiver).to eq object.class }
				it { expect(method_name).to eq :new }

				its_result { is_expected.to be_instance_of Object }
			end

			describe '#to_s' do
				it { expect(receiver).to eq object }
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
					it { expect(receiver).to eq object }
					it { expect(method_name).to eq :puts }

					its_result { is_expected.to be_nil }
				end
			end

			context 'when missing' do
				let :have_emitted_warning do
					have_received(:warn)
							.with(/Testing undefined method/)
				end

				before { allow(self).to receive :warn }

				describe '#undefined_method' do
					it { expect(receiver).to eq object }
					it { expect(method_name).to eq :undefined_method }

					it { expect { subject[] }.to raise_error NoMethodError }
					it { expect { subject   }.not_to raise_error }

					it 'emits a warning' do
						subject

						expect(self).to have_emitted_warning
								.once
					end

					context 'with bugs' do
						let(:method_name) { name }

						it { expect { subject[] }.to raise_error NoMethodError }
						it { expect { subject   }.to raise_error NoMethodError }

						it 'doesn’t emit a warning' do
							subject rescue nil

							expect(self).not_to have_emitted_warning
						end
					end
				end
			end

			context 'with a class' do
				subject { Object }

				shared_examples 'new' do
					it { expect(receiver).to eq Object }
					it { expect(method_name).to eq :new }

					its_result { is_expected.to be_instance_of Object }
				end

				describe('.new') { it_behaves_like 'new' }

				describe('#new') { it_behaves_like 'new' }
			end

			context 'with a module' do
				subject { Kernel }

				shared_examples 'pp' do
					it { expect(receiver).to eq Kernel }
					it { expect(method_name).to eq :pp }

					its_result                        { is_expected.to be_nil }
					its_result(argument = Object.new) { is_expected.to eq argument }
				end

				describe('.pp') { it_behaves_like 'pp' }

				describe('#pp') { it_behaves_like 'pp' }
			end
		end

		context 'when nested' do
			describe '.define_method' do
				before { receiver.class.define_method method_name, &block }

				describe '#my_method' do
					let(:block) { -> { :result } }

					its_result { is_expected.to eq :result }
				end
			end
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
