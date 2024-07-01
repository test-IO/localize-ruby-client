# LocalizeRubyClient

Helps you to connect your application to [localize-docs.cirro.io](https://localize-docs.cirro.io/) easily.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add localize_ruby_client
```
If bundler is not being used to manage dependencies, install the gem by executing:
```bash
gem install localize_ruby_client
```
Set your configurations:
```ruby
LocalizeRubyClient.configure do |config|
  config.app_id = 'your_app_id'
  config.private_key = 'your_private_key'
  config.root_path_to_save = '/path/to/save/files'
end
```

## Support for Railties
This gem includes `Railties` integration to automatically load Rake tasks when used within a Rails application. If your project uses Rails, you do not need to manually load the Rake tasks; they will be available as soon as the gem is included in your Gemfile and bundled.

### For projects that do not use Rails.

Add these lines to the Rakefile in your application

```ruby
# These lines are needed to load rake tasks of the LocalizeRubyClient gem.
spec = Gem::Specification.find_by_name 'localize_ruby_client'
rakefile = "#{spec.gem_dir}/lib/tasks/localize_ruby_client.rake"
load rakefile
```

Details about secrets [here](https://localize-docs.cirro.io/docs/authentication)


## Requirements
* Ruby 3.0.0 or higher

## Rake Tasks
The `localize_ruby_client` gem provides several Rake tasks to help manage your localization processes. These tasks will be automatically available in your Rails project due to the integration with `Railties`.

### Available Rake Tasks

```bash
rake localize_ruby_client:upload_file[project_uid, path_to_file, source_language_code, conflict_mode]
```

Uploads a file to the localization service.
```bash
rake localize_ruby_client:translate[project_uid]
```
Initiates a translation request for the specified project.

```bash
rake localize_ruby_client:update_translations[project_uid]
```

Updates translations for the specified project.

```bash
rake localize_ruby_client:upload_and_translate_file[project_uid, path_to_file, source_language_code, conflict_mode]
```

A composite task that uploads a file, initiates a translation request, and updates translations.

## Usage

For [Export all files endpoint](https://localize-docs.cirro.io/docs/continuous_projects/export_all) use next line:

```
LocalizeRubyClient.new.update_translations(project_uid: 42)
```

For [Import a file](https://localize-docs.cirro.io/docs/continuous_projects/import) you should add parameters:

```
LocalizeRubyClient.new.upload_file(project_uid: 42, file: "your_file.yml", source_language_code: "en", conflict_mode: "replace")
```
*As example we added our values of parameters, you should add yours.

For [Translate missing strings](https://localize-docs.cirro.io/docs/continuous_projects/translate_missing_strings):

```
LocalizeRubyClient.new.translate(project_uid: 42)
```

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
