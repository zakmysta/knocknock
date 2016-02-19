class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.string :token
      t.references :authenticatee, polymorphic: true, index: true

      t.timestamps
    end
    add_index :access_tokens, :token
  end
end
