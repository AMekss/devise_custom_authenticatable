## v0.0.1

* initial release, basic functionality

## v0.0.2

* Fix: compatibility with default :database_authenticatable strategy, so they both can work together or separate.

## v0.1.0

* Feature: generate session routes for :custom_authenticatable strategy

## v0.1.1

* Checked and confirmed that all functionality work with devise >= 2.0

## v0.2.0

* Feature: fail authentication if `#valid_for_custom_authentication?` returns false (use `#skip_custom_strategies` in order to pass to another stategy)
* Feature: `#after_custom_authentication` method added
