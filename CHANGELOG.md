## [Unreleased]

## [0.1.0] - 2024-03-11

- Initial release

## [0.2.0] - ?

### Fixed
- Resolved critical issues with gem installation.
- Ensured gem name consistency across all files and references (localize_ruby_client).

### Removed
- Dropped support for environment variables (ENVs).
- Removed RBS support.

### Added
- Introduced the ability to configure the gem from the target project.
- Added `Railtie` support for Rails projects, enabling automatic loading of rake tasks for file translations.
- Included `Pry` gem as a debugger for development and test environments.

### Changed
- Refactored gem library structure:
  - Split main class logic into smaller, separate helpers for easier maintainability.
- Updated rake task invocation:
  - Switched to named attributes instead of indexed arguments to prevent order confusion and allow skipping optional arguments.
  - Set a default value for `conflict_mode` to `replace` if skipped.

### Documentation
- Enhanced README.md with detailed sections on:
  - Available rake tasks.
  - Usage instructions for rake tasks.
  - `Railtie` support for Rails projects.