# ECOMMERCE MARKET

### DESCRIPTION

[Requirments](https://sequra.github.io/backend-challenge/)

This app implements a feature for generating Disbursement based on Merchant orders. Background job syncs daily, right after midnight, and processes each order from the previous day. During processing also it calculates `commission_fee` and `total_amount` which will paid into the Merchant account.

### INSTALLATION & SETUP

Requirments:
  - `ruby` v3.2.0
  - `RubyOnRails` v7.1
  - `PostgreSQL`
  - `Docker` (optional)

To set up this app please follow the steps below:

go to app directory `ecommerce-market` and install dependencies:
```bash
bundle install

```
after that, let's create database and run migration:
```bash
rails db:create # create database for our app
rails db:migrate # run migrations prepered for our app
```

now, we are ready to import `CSV` files, to do so, I have prepared two rake tasks

```bash
rake ecommerce_market:import_merchants
rake ecommerce_market:import_orders

```
***please note: running order is important, please run them like above***

which is importing `Merchants` and `Orders` from prepared and uploaded `CSV` files located in the `data` directory.

When import `Orders` and `Merchants` are done, we are ready to generate for imported `Orders` -> `Disbursements`.
To do so, we have to run task:

```bash
rake ecommerce_market:build_disbursements

```

***PLEASE NOTE*** it's take time

there is also task
```bash
rake ecommerce_market:show_stats
```
which showing (after `rake ecommerce_market:build_disbursements`) statistics


running RSpec:
```bash
rspec spec
```

running `rubocop` checks
```bash
rubocop
```

### RUNNING APP LOCALLY

To run app locally you need to run:

In one terminal tab run:
```bash
rails s
```

in another one:
```bash
bundle exec sidekiq
```
### DOCKER WAY

TODO

### STATISTIC RESULTS

Below you will find out result from calculated Disbrusements based on imported data from `CSV` files

<table>
  <thead>
    <tr>
      <th>Year</th>
      <th>Number of disbursements</th>
      <th>Amount disbursed to merchants</th>
      <th>Amount of order fees</th>
      <th>Number of monthly fees charged (From minimum monthly fee)</th>
      <th>Amount of monthly fee charged (From minimum monthly fee)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>2022</td>
      <td>2167</td>
      <td>38,439,158.23 €</td>
      <td>347,319.40 €</td>
      <td>74</td>
      <td>9,240.00 €</td>
    </tr>
    <tr>
      <td>2023</td>
      <td>13329</td>
      <td>187,054,761.55 €</td>
      <td>1,695,618.73 €</td>
      <td>374</td>
      <td>9,240.00 €</td>
    </tr>
  </tbody>
</table>

### ASSUMPTIONS
Some assumptions that I made during work:
  - I assumed that this calculating merchant disbursements feature is a part of a bigger monolith app
  - Regarding processing `Orders`, I assumed that we would like to process once a day
  - Regarding `by 8:00 UTC daily` I assumed, that should be `AM`, thanks to that, we can run the background job right after the date change, and process orders from the day before, for example: `on 25.01` we will process completed `Orders`
  - I assumed based on `CSV` file that `primary_key` is the `uuid` type
  - Regarding `reference` and `merchant reference` from `CSV` files, I assumed that are used to show up connection between those, but I decided to change the names and values of on `uuid` type
  - I assumed that importing from `CSV` will be one-time action so I located logic into rake tasks
  - Because I worked on my own on this assessment I committed to `main` branch by default, in another case I would prepare this feature in a separate branch. Looking at the "size" of this feature, I would consider splitting it into smaller parts

### IDEAS/THOUGHTS:
Below you can find out some ideas and thoughts:
  - To speed up importing `CSV` files I introduced the `activerecord-import` gem
  - Because of file size, especially, `orders.csv` I would recommend running initial order import and building disbursements in time when the database isn't too busy because it took some time to process each `Order`
  - Rake task `rake ecommerce_market:build_disbursements` could be run in a background job, because of its time of first execution
  - There is also room for improvement in the case of `validators` for each model, I think. That would require some domain specification
  - I would like to suggest a `boolean` field `paid` or enum `state` which could take care of state-specific `Disbursement` in case of further processing
  - In case of searching by `Date` range, in case of "much wider" range, or in case of table increase I would try to add indexes for the `DateTime` field in a needed database table
  - I would like also to add some `Date` range manager, where I could keep all methods related to the `Date` range, it could be useful i.e in the `Merchant` class or other
  - I have added also `calculators` for calculating the amount of fees or payout commission, I used them, because that help keep the model fit and the calculation process is separated and can be changed/new attached, or reused
  - I would like also suggest to add `currency` attribute for `Order` model
  - In case of rising methods in each model file, I would suggest splitting them into logic parts and moving into concerns or modules
  - In case of `Disbursements` I would recommend/consider soft delete mechanism to keep created entity, especially if they are related to money
  - I have included `service_objects` which taking care currently some more complex task, like `generate` or `regenerate` disbursments
