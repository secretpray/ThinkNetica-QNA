# rails g migration add_references_to_answers user:references
class AddReferencesToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :user, null: false, foreign_key: true
  end
end
