class AddSecretToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :secret, :string
  end
end
