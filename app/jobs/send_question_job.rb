class SendQuestionJob < ApplicationJob
  queue_as :default

  def perform(question)
    html = ApplicationController.render(partial: 'questions/question_for_bc', locals: {question: question})
    ActionCable.server.broadcast 'questions_channel', question: question, author_id: question.user_id, html: html, action: :create    # author_id: current_user&.id,    
    Rails.logger.info data                                
  end
end
