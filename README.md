# Multilang-hstore

[![Build Status](https://travis-ci.org/bithavoc/multilang-hstore.svg)](https://travis-ci.org/bithavoc/multilang-hstore)

> Multilang is a small translation library for translating database values for Active Support/Rails 4 using the [Hstore datatype](http://www.postgresql.org/docs/9.0/static/hstore.html).

This project is a fork of [artworklv/multilang](https://github.com/artworklv/multilang) with some remarkable differences:

* Replaced YAML text fields in favor of Hstore fields.
* The translation hash is no longer limited to locales in `I18n.available_locales`.
* Support for Rails 3 and Rails 4.

## Installation

### Rails 3

The last version of the gem for the Rails 3 series is [0.4](https://github.com/bithavoc/multilang-hstore/tree/v0.4). You need configure the multilang gem inside your gemfile:

    gem 'multilang-hstore'

Do not forget to run:

    bundle install

### Rails 4

Starting with version `1.0.0`, this gem is intented to be used in Rails 4. If you are migrating an existing project from Rails 3, make sure you read [Migrating to Rails 4](#Migrating-to-Rails-4).

You need configure the multilang gem inside your gemfile:

    gem 'multilang-hstore', '~> 1.0.0'

Do not forget to run:

	bundle install

## Basic Usage

This is a walkthrough with all steps you need to setup multilang translated attributes, including model and migration.

We're assuming here you want a Post model with some multilang attributes, as outlined below:

    class Post < ActiveRecord::Base
      multilang :title
    end

or

    class Post < ActiveRecord::Base
      multilang :title, :description, :required => true, :length => 100
    end

The multilang translations are stored in the same model attributes (eg. title):

You may need to create migration for Post as usual, but multilang attributes should be in hstore type:
  
    create_table(:posts) do |t|
      t.hstore :title
      t.timestamps
    end

Thats it!

Now you are able to translate values for the attributes :title and :description per locale:

    I18n.locale = :en
    post.title = 'Multilang rocks!'
    I18n.locale = :lv
    post.title = 'Multilang rulle!'

    I18n.locale = :en
    post.title #=> Multilang rocks!
    I18n.locale = :lv
    post.title #=> Multilang rulle!


You may assign attributes through auto generated methods (this methods depend from I18n.available_locales):

    I18n.available_locales #=> [:en. :lv]

    post.title_en = 'Multilang rocks!'
    post.title_lv = 'Multilang rulle!'

    post.title_en #=>  'Multilang rocks!'
    post.title_lv #=>  'Multilang rulle!'

You may use initialization if needed:

    Post.new(:title => {:en => 'Multilang rocks!', :lv => 'Multilang rulle!'})

or

    Post.new(:title_en => 'Multilang rocks!', :title_lv => 'Multilang rulle!')

Also, you may ise same hashes with setters:

    post.title = {:en => 'Multilang rocks!', :lv => 'Multilang rulle!'} 

## Attribute methods

You may get other translations via attribute translation method:

    post.title.translation[:lv] #=> 'Multilang rocks!'
    post.title.translation[:en] #=> 'Multilang rulle!'
    post.title.translation.locales #=> [:en, :lv]

If you have incomplete translations, you can get translation from other locale:

    post.title = {:en => 'Multilang rocks!', :lv => ''}
    I18n.locale = :lv
    post.title.any #=> 'Multilang rocks!'

The value from "any" method returns value for I18n.current_locale or, if value is empty, it searches through all locales. It takes searching order from I18n.available_locales array.

## Validations

Multilang has some validation features:

    multilang :title, :length => 100  #define maximal length validator
    multilang :title, :required => true #define requirement validator for all available_locales
    multilang :title, :required => 1 #define requirement validator for 1 locale
    multilang :title, :required => [:en, :es] #define requirement validator for specific locales
    multilang :title, :format => /regexp/ #define validates_format_of validator

## Error messages

To get a custom message you will need to use one of this solutions:

1. Use the message in the declaration

    multilang :title, :required => 1, :message => 'Not enough translations'

2. Write a new key in your translations file. Ex:

    [config/locales/yourtranslationsfile.yml]
    errors:
      messages:
        insufficient-translations:
          one: 'We need at least one tranlation.'
          other: 'We need at least %{count} tranlations.'

## Tests

Test runs using a temporary database in your local PostgreSQL server:

Create a test database:

    $ createdb multilang-hstore-test

Create the [hstore extension](http://www.postgresql.org/docs/9.1/static/sql-createextension.html):

    psql -d multilang-hstore-test -c "CREATE EXTENSION IF NOT EXISTS hstore"

Create the role *postgres* if necessary:

    $ createuser -s -r postgres 

Finally, you can run your tests:
  
    rspec	

## Migrating to Rails 4

Migrating to Rails 4 and multilang-hstore 1.x is a very straightforward process.

### Deprecated Dependencies

Rails 4 has built-in support for `hstore` datatype, so using any dependency to `activerecord-postgres-hstore` must be removed from your Gemfile:

### Mass-Assignment 

Mass-assignment was deprecated in Rails 4, so it was in our gem. You will receive an error similar to this:

    Multilang::Exceptions::DeprecationError: :accessible was deprecated starting multilang-hstore >= 1.0.0 which is intended for Rails >= 4.0.0. Check more info about the deprecation of mass-asignment in Rails 4

This basically means you are trying to use the option `:accessible` which is deprecated. Removing the option will solve the issue:

Before:

	class Post < ActiveRecord::Base
	  multilang :title, :accessible=>true
	end

After:

    class Post < ActiveRecord::Base
      multilang :title
	end

## Bugs and Feedback

Use [http://github.com/bithavoc/multilang-hstore/issues](http://github.com/bithavoc/multilang-hstore/issues)

## License(MIT)

* Copyright (c) 2012 - 2014 Bithavoc and Contributors - http://bithavoc.io
* Copyright (c) 2010 Arthur Meinart
