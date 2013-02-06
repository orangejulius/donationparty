class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :url
      t.string :charity
      t.timestamp :expire_time
      t.boolean :closed, default: false
      t.boolean :failed
      t.integer :max_amount
      t.string :winning_address1
      t.string :winning_address2
      t.string :secret_token

      t.timestamps
    end
  end
end
