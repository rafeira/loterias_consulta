class CreateRaffles < ActiveRecord::Migration[6.1]
  def change
    create_table :raffles do |t|
      t.string :name
      t.integer :contest_number
      t.datetime :contest_date
      t.bigint :contest_date_milliseconds
      t.string :place_realization
      t.string :apportionment_processing
      t.string :accumulated
      t.decimal :accumulated_value
      t.string :dozens
      t.decimal :total_collection
      t.integer :next_contest
      t.datetime :next_contest_date
      t.bigint :next_contest_date_milliseconds
      t.decimal :estimated_value_next_contest
      t.decimal :valor_acumulado_especial
      t.string :special_accumulated_value
      t.boolean :special_contest
      t.timestamps
    end
  end
end
