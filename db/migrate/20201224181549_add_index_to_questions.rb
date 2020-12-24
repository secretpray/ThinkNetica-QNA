class AddIndexToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_index :questions, :title, unique: true
  end
end
