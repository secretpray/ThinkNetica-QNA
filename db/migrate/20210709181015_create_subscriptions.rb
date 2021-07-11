class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end

    add_index(:subscriptions, [:user_id, :question_id], unique: true)
  end
end
