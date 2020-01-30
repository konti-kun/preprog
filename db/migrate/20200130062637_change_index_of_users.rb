class ChangeIndexOfUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :uid, unique: true
    remove_index :users, column: :email, unique: true
  end

  def up
    remove_index :users, :email
  end

  def down
    add_index :users, :email, unique: true
  end
end
