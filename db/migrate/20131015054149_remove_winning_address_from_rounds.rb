class RemoveWinningAddressFromRounds < ActiveRecord::Migration
  def change
    remove_column :rounds, :winning_address1, :string
    remove_column :rounds, :winning_address2, :string
  end
end
