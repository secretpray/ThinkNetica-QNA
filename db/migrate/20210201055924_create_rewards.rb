class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.references :user, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
