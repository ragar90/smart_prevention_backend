class CreatePositiions < ActiveRecord::Migration
  def change
    create_table :positiions do |t|
      t.integer :user_id
      t.float :latitude
      t.float :longitud

      t.timestamps
    end
  end
end
