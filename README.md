# LocalizeRubyClient

Helps you to connect your Rails application to [localize-docs.cirro.io](https://localize-docs.cirro.io/) easily by managing your localization files with three simple Rake tasks.

## Installation

Install the gem and add it to the application's Gemfile by executing:

```bash
bundle add localize_ruby_client
```
If Bundler is not being used to manage dependencies, install the gem by executing:
```bash
gem install localize_ruby_client
```
Set your configurations:
```ruby
LocalizeRubyClient.configure do |config|
  config.app_id = 'your_app_id'
  config.private_key = 'your_private_key'
  config.project_id = 'your project_uid'
end
```
Details about secrets [here](https://localize-docs.cirro.io/docs/authentication)

## Support for Railties
This gem includes `Railties` integration to automatically load Rake tasks when used within a Rails application. They will be available as soon as the gem is included in your Gemfile and bundled.

## Requirements
* Ruby 3.0.0 or higher
* Rails app with `config/locales` folder

## Usage
The `localize_ruby_client gem` provides several `Rake` tasks to help manage your localization processes. These tasks will be automatically available in your `Rails` project due to the integration with `Railties`.

### Uploading Local YAML Files
To upload each local YAML file in the `config/locales` folder to the Localize API, run:

```bash
rake localize_ruby_client:upload_files[conflict_mode]
```
* conflict mode is optional, by default is `replace` if missed
### Translating Uploaded Files
To start the translation of the uploaded files via the Localize API, run:
```bash
rake localize_ruby_client:translate
```

### Downloading Translated Files
To download the translated files back into the `config/locales` folder, run:
```bash
rake localize_ruby_client:update_translations
```

### Note
Some shells (like zsh) require you to:
 * escape the brackets: `rake my_task\['arg1'\]`
 * wrap name in quotes: `rake 'my_task[arg1]'`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

<!-- To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org). -->

## Contributing

* Fork the project.
* Run `bundle`
* Make your feature addition or bug fix.
* Add tests for it.
* Commit, do not mess with version, or history.
* Send a pull request.
