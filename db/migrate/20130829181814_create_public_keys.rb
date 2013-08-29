class CreatePublicKeys < ActiveRecord::Migration
  def change
    create_table :public_keys do |t|
      t.string :name
      t.integer :user_id
      t.text :value

      t.timestamps
    end
  end
end
