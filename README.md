**Cab Store** Physical store which sells products.

## Install project

1. Required environment
  * Required ruby version: ```2.2.1```, if we don't have it, we should execute ```rvm install 2.2.1```
  * Required rubygems version: ```2.4.6```, if we don't have it, once ruby is installed we should execute
  ```rvm rubygems 2.4.6```
  * Create a gemset for the project:, we should execute ```rvm ruby-2.2.1@cab_store --create```
  * Create a ```.ruby-version``` file in the root folder with the content ```ruby-2.2.1```
  * Create a ```.ruby-gemset``` file in the root folder with the content ```cab_store```
  * Finally, we should see something like this when executing ```gem env```:

  ```
  RubyGems Environment:
    - RUBYGEMS VERSION: 2.4.6
    - RUBY VERSION: 2.2.1 (2015-02-26 patchlevel 85) [x86_64-darwin14]
    - INSTALLATION DIRECTORY: /Users/enrique_cruz_garrido/.rvm/gems/ruby-2.2.1@cab_store
    - RUBY EXECUTABLE: /Users/enrique_cruz_garrido/.rvm/rubies/ruby-2.2.1/bin/ruby
    - EXECUTABLE DIRECTORY: /Users/enrique_cruz_garrido/.rvm/gems/ruby-2.2.1@cab_store/bin
    - SPEC CACHE DIRECTORY: /Users/enrique_cruz_garrido/.gem/specs
    - SYSTEM CONFIGURATION DIRECTORY: /etc
    - RUBYGEMS PLATFORMS:
      - ruby
      - x86_64-darwin-14
    - GEM PATHS:
       - /Users/enrique_cruz_garrido/.rvm/gems/ruby-2.2.1@cab_store
       - /Users/enrique_cruz_garrido/.rvm/gems/ruby-2.2.1@global
    - GEM CONFIGURATION:
       - :update_sources => true
       - :verbose => true
       - :backtrace => false
       - :bulk_threshold => 1000
    - REMOTE SOURCES:
       - https://rubygems.org/
    - SHELL PATH:
       - /Users/enrique_cruz_garrido/.rvm/gems/ruby-2.2.1@cab_store/bin
       - /Users/enrique_cruz_garrido/.rvm/gems/ruby-2.2.1@global/bin
       - /Users/enrique_cruz_garrido/.rvm/rubies/ruby-2.2.1/bin
       - /Users/enrique_cruz_garrido/.rvm/bin
       - /usr/local/bin
       - /usr/bin
       - /bin
       - /usr/sbin
       - /sbin
  ```

2. Installation
  * Install rails: ```gem install rails -v 4.2.4```
  * Install bundler: ```gem install bundler -v 1.10.6```
  * Install rvm gem: ```gem install rvm -v 1.11.3```
  * Install rake: ```gem install rake -v 10.4.2```
  * Execute bundler: ```bundle install --path vendor```
  * Add database host name:
    * Edit file ```/etc/hosts```
    * Add the following line: ```127.0.0.1  database```
  * Create database and its structure: ```bundle exec rake db:create && bundle exec rake db:schema:load```

## Execute project

  * We can execute seeds to populate the database:
    * Execute seed:
      * ```rake db:seed```

## Running tests

  * Create test database: ```bundle exec rake db:test:prepare```
  * Run the suite: ```bundle exec rake spec```

  We recommend using zeus for a lot of tasks in the project, for example: running server, console..., to use it you should
  install the zeus gem (```gem install zeus -v 0.15.4```) and run the zeus process (```zeus start```).

## Populate database with test data

  It is possible to create some test data in order to avoid the need of manually create it, this can be done executing:

  ```bundle exec rake db:seed```

  This will create some test product and pricing rules:
  * Product 1:
    * code: VOUCHER
    * name: Cabify Voucher
    * price: 5.00

  * Product 2:
    * code: TSHIRT
    * name: Cabify T-Shirt
    * price: 20.00

  * Product 3:
    * code: MUG
    * name: Cabify Coffee Mug
    * price: 7.50

## Execute store

  * Run console.
    * First test:

        ```
        checkout = Checkout.new(PricingRule.all)
        checkout.scan(Product.find_by_code('VOUCHER'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.scan(Product.find_by_code('MUG'))
        checkout.total
        ==> 32.5
        ```
    * Second test:

        ```
        checkout = Checkout.new(PricingRule.all)
        checkout.scan(Product.find_by_code('VOUCHER'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.scan(Product.find_by_code('VOUCHER'))
        checkout.total
        ==> 25.0
        ```
    * Third test:

        ```
        checkout = Checkout.new(PricingRule.all)
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.scan(Product.find_by_code('VOUCHER'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.total
        ==> 81.0
        ```
    * Fourth test:

        ```
        checkout = Checkout.new(PricingRule.all)
        checkout.scan(Product.find_by_code('VOUCHER'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.scan(Product.find_by_code('VOUCHER'))
        checkout.scan(Product.find_by_code('VOUCHER'))
        checkout.scan(Product.find_by_code('MUG'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.scan(Product.find_by_code('TSHIRT'))
        checkout.total
        ==> 74.5
        ```