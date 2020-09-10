class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.belongs_to :user
      t.belongs_to :room

      t.timestamps
    end
  end
end
