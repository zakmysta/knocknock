class CreateAccessToken < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.string :token
      t.references :authenticatee, polymorphic: true
    end
    add_index :access_tokens, :token, unique: true
  end
end
