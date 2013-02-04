class RemoveFailedFromRound < ActiveRecord::Migration
  def up
    remove_column :rounds, :failed
  end

  def down
    add_column :rounds, :failed, :boolean
  end
end
