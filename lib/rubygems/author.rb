# frozen_string_literal: true

module Gem # :nodoc:
	# # Gem Author
	#
	# This class holds authors info to be used primarily in gem specs.
	#
	# ## Usage
	#
	# 1. Inherit +Gem::Author+ inside your gem and add the authors’ info.
	#
	# Example:
	#
	#     module MyLib
	#       class Author < Gem::Author
	#         new(
	#           name:   'Your Name',
	#           email:  'Your.Name@email.service',
	#           github: 'Your-GitHub-Username',
	#         )
	#       end
	#     end
	#
	# 2. You can call some helper methods now.
	#
	# Example:
	#
	#     Gem::Specification.new do |spec|
	#       spec.name     = 'my_lib'
	#       spec.version  = MyLib::VERSION
	#       spec.authors  = MyLib::Author.names
	#       spec.email    = MyLib::Author.emails
	#       spec.homepage = "#{MyLib::Author.github_url}/#{spec.name}"
	#     end
	#
	Author ||= Struct.new(
			:name,
			:email,
			:github,
	) do
		def self.inherited child
			super

			child.class_eval do
				class << self
					attr_reader :all

					include Author::ClassMethods
				end
			end
		end

		module self::ClassMethods # rubocop:disable Lint, Style
			def new(...) = (@all ||= []) << super

			def names      = all.filter_map &:name
			def emails     = all.filter_map &:email
			def github_url = all.filter_map(&:github_url).first
		end

		def github_url = github && "https://github.com/#{github}"
	end
end
