class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name
      t.float :latitude_position
      t.float :longitude_position
      t.boolean :zone_type

      t.timestamps
    end
  end
end
