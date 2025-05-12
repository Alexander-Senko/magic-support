## [0.2.0] — UNRELEASED

### RSpec

#### Method specs

##### Added

- Receiver objects are exposed via `receiver`.
- Emit warnings on missing methods.

##### Fixed

- Don’t swallow unrelated name errors.


## [0.1.0] — 2024-11-28

### Added

#### `Kernel`

- `#optional` as a conditional `#then`.

#### Gems

- `Gem::Author` for authors info to be used primarily in gem specs.

#### RSpec

- API for method specs (`rspec/method`).
	- API for delegated methods. 
