class CreateAuthToken < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.references :user, index: true
      t.string :provider, index: true
      t.string :uid, index: true
      t.json :info
      t.json :credentials
      t.json :extra

      t.timestamps null: false
    end
  end
end
