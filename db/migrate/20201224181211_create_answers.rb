class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :title
      t.text :body
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
    add_index :answers, :title
  end
end
