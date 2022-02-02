class CreateWinnerPlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :winner_places do |t|
      t.belongs_to :raffle, foreign_key: true, null: false
      t.string :place
      t.string :city
      t.string :uf
      t.integer :winners_quantity
      t.boolean :electronic_channel
      t.timestamps
    end
  end
end
