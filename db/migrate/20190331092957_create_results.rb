class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.references :game, index: true
      t.integer :points
      t.jsonb :correct_answers, default: []
      t.jsonb :wrong_answers, default: []
    end
  end
end
