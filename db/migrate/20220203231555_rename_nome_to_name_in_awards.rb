class RenameNomeToNameInAwards < ActiveRecord::Migration[6.1]
  def change
    rename_column :awards, :nome, :name
  end
  def down
    rename_column :awards, :name, :nome
  end
end
