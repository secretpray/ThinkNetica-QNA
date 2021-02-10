Vote.delete_all
Reward.delete_all
Answer.delete_all
Question.delete_all
User.delete_all

rails_path = Rails.root.join('app', 'assets', 'images')

DATA = [
  {
    'Как расшифровывается HTML?' => ['Hyper Text Markup Language', 'Home Tool Markup Language', 'Hyperlinks and Text Markup Language'],
    'Какая запись для гиперссылки верна?' => [ '<a href="some_link"...', '<a http="some_link"...', ' <a="some_link"...' ],
    'Что лучше использовать во Frontend?' => [ 'React', 'Vue JS', 'Angular', 'Laravel' ]
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
  random_user_id = User.find(User.pluck(:id).sample).id
  db_question = Question.create!(title: question, body: question, user_id: random_user_id)
  answers.each do |answer|
    random_id = User.offset(rand(User.count)).first.id
    Answer.create!(body: answer, question_id: db_question.id, user_id: random_id)
  end
end

answer = Answer.all.sample
question = answer.question
question.build_reward(name: "Gold best", question_id: question.id, user_id: answer.user_id)
question.reward.badge_image.attach(io: File.open(rails_path/'no_image_available.png'), 
                                                 filename: 'no_image_available.png', 
                                                 content_type: 'image/png')
question.save
answer.update(best: true)

Vote.create!(score: 1, user_id: User.first.id, votable_type: 'Question', votable_id: 1)
Vote.create!(score: 1, user_id: User.second.id, votable_type: 'Question', votable_id: 1)
Vote.create!(score: 1, user_id: User.find(3).id, votable_type: 'Question', votable_id: 1)
Vote.create!(score: 1, user_id: User.find(4).id, votable_type: 'Question', votable_id: 1)
Vote.create!(score: 1, user_id: User.find(5).id, votable_type: 'Question', votable_id: 1)
Vote.create!(score: -1, user_id: User.last.id, votable_type: 'Question', votable_id: 1)

Vote.create!(score: -1, user_id: User.first.id, votable_type: 'Question', votable_id: 2)
Vote.create!(score: -1, user_id: User.second.id, votable_type: 'Question', votable_id: 2)
Vote.create!(score: -1, user_id: User.find(3).id, votable_type: 'Question', votable_id: 2)
Vote.create!(score: 1, user_id: User.find(4).id, votable_type: 'Question', votable_id: 2)
Vote.create!(score: 1, user_id: User.find(5).id, votable_type: 'Question', votable_id: 2)
Vote.create!(score: -1, user_id: User.last.id, votable_type: 'Question', votable_id: 2)

Vote.create(score: 1, user_id: User.first.id,votable_type: 'Answer', votable_id: 1)
Vote.create(score: 1, user_id: User.second.id, votable_type: 'Answer', votable_id: 1)
Vote.create!(score: -1, user_id: User.find(3).id, votable_type: 'Answer', votable_id: 1)
Vote.create!(score: 1, user_id: User.find(4).id, votable_type: 'Answer', votable_id: 1)
Vote.create!(score: -1, user_id: User.find(5).id, votable_type: 'Answer', votable_id: 1)
Vote.create!(score: -1, user_id: User.last.id, votable_type: 'Answer', votable_id: 1)

Vote.create(score: 1, user_id: User.first.id,votable_type: 'Answer', votable_id: 2)
Vote.create(score: 1, user_id: User.second.id, votable_type: 'Answer', votable_id: 2)
Vote.create!(score: -1, user_id: User.find(3).id, votable_type: 'Answer', votable_id: 2)
Vote.create!(score: -1, user_id: User.find(4).id, votable_type: 'Answer', votable_id: 2)
Vote.create!(score: -1, user_id: User.find(5).id, votable_type: 'Answer', votable_id: 2)
Vote.create!(score: -1, user_id: User.last.id, votable_type: 'Answer', votable_id: 2)


User.first.update(role: 'admin')
p "Created #{Question.count} questions."
p "Created #{Answer.count} answers."
p "Created #{User.count} users."
p "Created #{Vote.count} votes."
p '- * -' * 14
p "Created admin user: #{User.find_by_role('admin').email}"
p "Create best answer id: #{Answer.find_by_best(true).id}, body: #{Answer.find_by_best(true).body}"
p "Create #{Reward.count} reward with badge image (no_image_available.png)? - #{question.reward.badge_image.attached?}"