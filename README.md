# Localize::Ruby::Client

Helps you to connect your application to [localize-docs.cirro.io](https://localize-docs.cirro.io/) easily.

## Installation

Install the gem and add to the application's Gemfile by executing:

```
bundle add localize-ruby-client
```
If bundler is not being used to manage dependencies, install the gem by executing:
```
gem install localize-ruby-client
```
Add your credentials to .env
```ruby
APP_ID=your_application_id_here
PRIVATE_KEY=your_private_key_here
PROJECT_UID=your_project_id_here
ROOT_PATH_TO_SAVE=path_you_want_to_save_translated
# usually last one is ./config/locales/
```
Add these lines to the Rakefile in your application

```ruby
# These lines are needed to load rake tasks of the Client gem.
spec = Gem::Specification.find_by_name 'client'
rakefile = "#{spec.gem_dir}/lib/tasks/client.rake"
load rakefile
```

Details about secrets [here](https://localize-docs.cirro.io/docs/authentication)


## Requirements
* Ruby 3.0.0 or higher

## Usage in terminal
For upload new file to Localize API, translate him, dounload and update locally use this command in your terminal:

```
rake client:upload_and_translate_file path_to_file source_language_code conflict_mode
```

For example:
```
rake client:upload_and_translate_file "./your/path_to/file.en.yml" "en" "replace"
```

## Usage

For [Export all files endpoint](https://localize-docs.cirro.io/docs/continuous_projects/export_all) use next line:

```
Client.new.update_translations
```

For [Import a file](https://localize-docs.cirro.io/docs/continuous_projects/import) you should add parameters:

```
Client.new.upload_file(file: "your_file.yml", source_language_code: "en", conflict_mode: "replace")
```
*As example we added our values of parameters, you should add yours.

For [Translate missing strings](https://localize-docs.cirro.io/docs/continuous_projects/translate_missing_strings):

```
Client.new.translate
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

* Fork the project.
* Run `bundle`
* Make your feature addition or bug fix.
* Add tests for it.
* Commit, do not mess with version, or history.
* Send a pull request.
