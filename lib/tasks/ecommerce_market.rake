# frozen_string_literal: true

require 'csv'

namespace :ecommerce_market do
  desc 'Importing Merchant from CSV file'
  task import_merchants: :environment do
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
    Disbursements::Regenerate.call
  end

  desc 'Generate some stats'
  task show_stats: :environment do
    grouped_disbursments = Disbursement.all.group_by { |item| item.created_at.strftime('%Y') }

    result = grouped_disbursments.map do |index, items|
      {
        year: index,
        number_of_disbursements: items.count,
        amount_disbursed_to_merchants: format_money(amount: items.pluck(:total_amount).sum.to_f.round(2)),
        amount_of_order_fees: format_money(amount: items.pluck(:commision_amount).sum.to_f.round(2)),
        charged_num_of_monthly_fee: items.pluck(:minimum_monthly_fee).select { |x| x > 0.0 }.size,
        amount_of_monthly_fee: format_money(amount: items.pluck(:minimum_monthly_fee).sum.to_f.round(2))
      }
    end

    puts result
  end

  # rubocop:disable Style/FormatString
  def format_money(amount:)
    sprintf('%.2f', amount).gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
  end
  # rubocop:enable Style/FormatString

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
