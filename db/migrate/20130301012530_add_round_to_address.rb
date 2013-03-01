class AddRoundToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :round_id, :integer
  end
end
