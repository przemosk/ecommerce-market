# frozen_string_literal: true

require 'csv'

namespace :ecommerce_market do
  desc 'Importing Merchant from CSV file'
  task import_merchant: :environment do
    merchants = []
    CSV.parse(csv_file(filename: 'merchants.csv'), headers: true, col_sep: ';') do |row|
      merchants << create_merchant_instance(row: row)
    end

    puts 'IMPORTING INTO DATABASE:'
    result = Merchant.import merchants
    puts "Import - inserted: #{result.num_inserts}; fails: #{result.failed_instances}"
  end

  desc 'Importing Order for Merchant from CSV file'
  task import_orders: :environment do
    abort('please run ecommerce_market:import_merchant before') if Merchant.all.empty?

    orders = []
    CSV.parse(csv_file(filename: 'orders.csv'), headers: true, col_sep: ';') do |row|
      orders << create_order_instance(row: row)
    end

    puts 'IMPORTING INTO DATABASE:'
    result = Order.import orders
    puts "Import - inserted: #{result.num_inserts}; fails: #{result.failed_instances}"
  end

  desc 'Building Disbursements for Orders'
  task build_disbursements: :environment do
    abort('please run ecommerce_market:import_orders before') if Order.all.empty?

    Merchant.joins(:orders).where(orders: { disbursement_id: nil }).find_in_batches(batch_size: 1_000) do |merchants_batch|
      merchants_batch.each do |merchant|
        merchant_orders = merchant.orders.group_by(&:created_at)

        merchant_orders.each do |date, orders|
          disbursement = merchant.disbursements.create!(created_at: date)

          disbursement.calculate_minimum_monthly_fee if merchant.disbursements.where(created_at: date.to_date.beginning_of_month..date).size == 1

          orders.map do |order|
            puts "processing order: #{order.id}"
            disbursement.add_order(order: order)
          end
        end
      end
    end
  end

  def create_order_instance(row:)
    Order.new(
      merchant_id: Merchant.find_by(name: row['merchant_reference']).id,
      amount: row['amount'],
      created_at: row['created_at'].to_datetime
    )
  end

  def create_merchant_instance(row:)
    Merchant.new(
      name: row['reference'],
      email: row['email'],
      live_on: row['live_on'].to_datetime,
      disbursement_frequency: row['disbursement_frequency'].downcase! == 'daily' ? 0 : 1,
      minimum_monthly_fee: row['minimum_monthly_fee']
    )
  end

  def csv_file(filename:)
    file_path = Rails.root + "data/#{filename}"
    File.read(file_path)
  end
end
