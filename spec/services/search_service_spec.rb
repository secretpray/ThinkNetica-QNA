require 'rails_helper'

RSpec.describe SearchService do
  let!(:questions) { create_list(:question, 4) }
  let!(:answers) { create_list(:answer, 4)}
  let!(:comments) { create_list(:comment, 4, commentable: questions.first)}

  it 'will call Question search' do
    expect(Question).to receive(:search).and_return(questions.first)
    SearchService.call(query: questions.first.title, type: 'Question')
  end


  it 'will call Answer search' do
    expect(Answer).to receive(:search).and_return(answers.first)
    SearchService.call(query: answers.first.body, type: 'Answer')
  end


  it 'will call Comment search' do
    expect(Comment).to receive(:search).and_return(comments.first)
    SearchService.call(query: comments.first.body, type: 'Comment')
  end


  it 'will call User search' do
    expect(User).to receive(:search).and_return(questions.first.user.email)
    SearchService.call(query: questions.first.user.email, type: 'User')
  end

  it 'will call ThinkingSphinx search' do
    expect(ThinkingSphinx).to receive(:search).and_return(questions.first)
    SearchService.call(query: questions.first.title, type: '')
  end
end
