# frozen_string_literal: true

# Migration which enable bult-in Postgres UUID type
class InitializeUuidModuleMigration < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto'
  end
end
