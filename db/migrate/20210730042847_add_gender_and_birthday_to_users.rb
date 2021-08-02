class AddGenderAndBirthdayToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :gender, :string
    add_column :users, :birthday, :datetime
  end
end
