class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string :email
      t.string :name
      t.string :stripe_token
      t.decimal :amount
      t.references :round

      t.timestamps
    end
    add_index :donations, :round_id
  end
end
