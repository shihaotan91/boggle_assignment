class CreateGameTable < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.boolean :completed
      t.datetime :start_time
      t.datetime :end_time
      t.string :token, unique: true
      t.jsonb :board
    end
  end
end
