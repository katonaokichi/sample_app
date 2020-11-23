class AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    # rails generate migration add_password_digest_to_users password_digest:string
    #とするこでadd_column :users,..が自動入力
    add_column :users, :password_digest, :string
  end
end
