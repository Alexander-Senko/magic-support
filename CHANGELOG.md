## [0.2.1] — 2025-05-13

### RSpec

#### Method specs

##### Fixed

- Method specs with implicit subjects got broken in v0.2.0.


## [0.2.0] — 2025-05-13

### Core extensions

#### Fixed

- Don’t forget to `require 'pathname'` as it’s not a core class.
- Don’t load all core extensions unless required explicitly.

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
