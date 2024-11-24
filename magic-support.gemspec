# frozen_string_literal: true

require_relative 'lib/magic/support/version'
require_relative 'lib/magic/support/authors'

Gem::Specification.new do |spec|
	spec.name        = 'magic-support'
	spec.version     = Magic::Support::VERSION
	spec.authors     = Magic::Support::Author.names
	spec.email       = Magic::Support::Author.emails
	spec.homepage    = "#{Magic::Support::Author.github_url}/#{spec.name}"
	spec.summary     = 'Active Support extended'
	spec.description = 'Utility classes and Ruby extensions beyond Active Support.'
	spec.license     = 'MIT'

	spec.metadata['source_code_uri'] = spec.homepage
	spec.metadata['changelog_uri']   = "#{spec.metadata['source_code_uri']}/blob/v#{spec.version}/CHANGELOG.md"

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	gemspec    = File.basename(__FILE__)
	spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
		ls.readlines("\x0", chomp: true).reject do |f|
			(f == gemspec) ||
					f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
		end
	end

	spec.required_ruby_version = '~> 3.2'
end
