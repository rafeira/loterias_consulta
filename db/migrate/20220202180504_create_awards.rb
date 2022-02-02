class CreateAwards < ActiveRecord::Migration[6.1]
  def change
    create_table :awards do |t|
      t.string :nome
      t.belongs_to :raffle, foreign_key: true, null: false
      t.integer :winners_quantity
      t.decimal :total_values
      t.integer :hits
      t.timestamps
    end
  end
end
