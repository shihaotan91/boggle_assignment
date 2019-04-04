class RemoveWrongAnswersColumnFromResult < ActiveRecord::Migration[5.2]
  def change
    remove_column :results, :wrong_answers
  end
end
