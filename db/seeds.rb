Answer.delete_all
Question.delete_all
User.delete_all

DATA = [
  {
    'Как расшифровывается HTML?' => ['Hyper Text Markup Language', 'Home Tool Markup Language', 'Hyperlinks and Text Markup Language'],
    'Какая запись для гиперссылки верна?' => [ '<a href="some_link"...', '<a http="some_link"...', ' <a="some_link"...' ]
  }
]

USERS = [
  { email: 'nemov@mail.com', password: 'secretus' },
  { email: 'alex@mail.com', password: 'secretus' },
  { email: 'max@mail.com', password: 'secretus' },
  { email: 'dim@mail.com', password: 'secretus' },
  { email: 'antm@mail.com', password: 'secretus' },
  { email: 'sss@mail.com', password: 'secretus' }
]
USERS.each do |user|
  User.create!(user)
end

DATA.first.each do |question, answers|
  # random_user_id = User.offset(rand(User.count)).first.id
  # random_user_id = User.select(:id).order('RANDOM()').limit(1).join.to_i
  random_user_id = User.find(User.pluck(:id).sample).id
  db_question = Question.create!(title: question, body: question, user_id: random_user_id)
  answers.each do |answer|
    random_id = User.offset(rand(User.count)).first.id
    # creators = Question.all.map(&:user_id)
    # all_users = User.all.map(&:id)
    # delta_id = all_users - creators
    # random_id = User.where(id: delta_id.sample) || random_user_id
    Answer.create!(body: answer, question_id: db_question.id, user_id: random_id)
  end
end

p "Created #{Question.count} questions."
# p Question.order(id: :desc)
p "Created #{Answer.count} answers."
p "Created #{User.count} users."
