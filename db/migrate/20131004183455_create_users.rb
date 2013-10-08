class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :twitter_account
      t.string :facebook_account
      t.string :email
      t.string :password_digest
      t.string :blood_type
      t.string :alergies, default: "none"
      t.text   :home_addres
      t.string :emergency_state, default: "unknown"
      t.float  :latitude_position
      t.float  :longitude_position
      t.string :emergency_contact_number
      t.string :medications_taken, default: "none"
      t.string :password_digest
      t.string :session_token

      t.timestamps
    end
  end
end
