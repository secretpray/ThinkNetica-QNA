# rails g migration add_references_to_questions user:references
class AddReferencesToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :user, null: false, foreign_key: true
  end
end
