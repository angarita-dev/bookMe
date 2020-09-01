class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.integer :capacity, null: false
      t.boolean :private, null: false
      t.string :img_url
      t.text :amenities, array: true, default: []


      t.timestamps
    end
  end
end
