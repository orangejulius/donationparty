class AddCharityReferenceToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :charity_id, :integer
  end
end
