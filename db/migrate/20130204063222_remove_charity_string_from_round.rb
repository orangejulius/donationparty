class RemoveCharityStringFromRound < ActiveRecord::Migration
  def up
    remove_column :rounds, :charity
  end

  def down
    add_column :rounds, :charity, :string
  end
end
