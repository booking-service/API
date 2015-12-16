class AddAccessTokenToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :access_token, :string
    add_column :merchants, :username, :string
  end
end
