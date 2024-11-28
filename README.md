# ✨ Magic Support

![GitHub Actions Workflow Status](
	https://img.shields.io/github/actions/workflow/status/Alexander-Senko/magic-support/ci.yml
)
![Code Climate maintainability](
	https://img.shields.io/codeclimate/maintainability-percentage/Alexander-Senko/magic-support
)
![Code Climate coverage](
	https://img.shields.io/codeclimate/coverage/Alexander-Senko/magic-support
)

Magic Support is a collection of utility classes and standard library extensions
that were found useful for my pet projects.

It’s inspired by [Active Support](
	https://github.com/rails/rails/tree/main/activesupport
).

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Core extensions

### Loading

Magic Support is broken into small pieces so that only the desired extensions can be loaded.
It also has some convenience entry points to load related extensions in one shot, even all of them.

#### Cherry-picking

For every single method defined as a core extension a note says where such a method is defined.

That means that you can `require` it like this:

```ruby
require 'magic/core_ext/<module>/<extension>'
```

Magic Support has been carefully revised so that cherry-picking a file loads only strictly needed dependencies, if any.

#### Loading grouped core extensions

As a rule of thumb, extensions to `SomeClass` are available in
one shot by loading `magic/core_ext/some_class`.

Thus, to load all extensions to `Kernel`:

```ruby
require 'magic/core_ext/kernel'
```

#### Loading all core extensions

You may prefer just to load all core extensions, there is a file for that:

```ruby
require 'magic/core_ext'
```

## Gems

### Author

It holds authors info to be used primarily in gem specs.

#### Loading

Pre-install Magic Support if you plan to use `Gem::Author` in your gemspec.

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

#### Usage

1. Inherit `Gem::Author` inside your gem and add the authors’ info.

	```ruby
	require 'rubygems/author'
	
	module MyLib
	  class Author < Gem::Author
	    new(
	      name:   'Your Name',
	      email:  'Your.Name@email.service',
	      github: 'Your-GitHub-Username',
	    )
	  end
	end
	```

2. You can call some helper methods now.

	```ruby
	Gem::Specification.new do |spec|
	  spec.name     = 'my_lib'
	  spec.version  = MyLib::VERSION
	  spec.authors  = MyLib::Author.names
	  spec.email    = MyLib::Author.emails
	  spec.homepage = "#{MyLib::Author.github_url}/#{spec.name}"
	end
	```

## RSpec

### Method specs

Enables one to write specs for single methods.

> [!WARNING]
> Planed for extraction into a separate gem.

#### Loading

Require it in `spec_helper.rb`:

```ruby
require 'rspec/method'
```

#### Usage

Include a method reference into the description.
The reference should start with either
- `.` for class methods or
- `#` for instance ones.

```ruby
RSpec.describe MyClass do
  describe '.class_method' do
    its([arg1, arg2]) { is_expected.to be return_value }
  end

  describe '#instance_method' do
    its([arg1, arg2]) { is_expected.to be return_value }
  end
end
```

> [!NOTE]
> Though `rspec/its` is not needed, it could come useful (see [the article on method testing](
> 	https://zverok.space/blog/2017-11-01-rspec-method-call.html
> )).

Within examples, `subject` is set to the corresponding `Method` instance.
In cases when the method couldn’t be found (e.g., due to delegation via `method_missing`), it’s set to a `Proc` instance
instead.
Anyway, one may treat it as something _callable_.

A method name is exposed as a `Symbol` via `method_name`.

> [!NOTE]
> `subject.name` may be undefined, use `method_name` instead.

##### Module specs

It’s recommended to use class method notation, when writing specs for module functions.

```ruby
RSpec.describe MyModule do
  describe '.module_function' do 
    # put the examples here
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Alexander-Senko/magic-support. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Alexander-Senko/magic-support/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Magic::Support project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Alexander-Senko/magic-support/blob/main/CODE_OF_CONDUCT.md).
