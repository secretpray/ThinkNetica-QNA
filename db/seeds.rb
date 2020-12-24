Answer.delete_all
Question.delete_all

DATA = [
  {
    'Как расшифровывается HTML?' => ['Hyper Text Markup Language', 'Home Tool Markup Language', 'Hyperlinks and Text Markup Language'],
    'Какая запись для гиперссылки верна?' => [ '<a href="some_link"...', '<a http="some_link"...', ' <a="some_link"...' ]
  }
]

DATA.first.each do |question, answers|
  db_question = Question.create!(title: question, body: question)
  answers.each do |answer|
    Answer.create!(title: answer, body: answer, question_id: db_question.id)
  end
end

p "Created #{Question.count} questions."
# p Question.order('id DESC')
p "Created #{Answer.count} answers."
# Answer.order('id DESC')
