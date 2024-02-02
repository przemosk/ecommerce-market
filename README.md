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
