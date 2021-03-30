class SendAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer, user)    
    ActionCable.server.broadcast  "questions/#{answer.question_id}/answers", 
                                    answer_body: answer.body,
                                    id: answer.id,
                                    question_id: answer.question_id,
                                    answers_count: answer.question.answers.count,
                                    author_id: user.id,
                                    created_at: answer.created_at,
                                    updated_at: answer.updated_at,
                                    author_email: answer.user.email,
                                    links: answer.links,
                                    files: answer.files.any?,
                                    files_html: files_html(answer.files),
                                    action: :create

      ActionCable.server.broadcast  'questions_channel', 
                                    id: answer.question_id,
                                    answers_count: answer.question.answers.count,
                                    action: :update_badge
  end

  def files_html(files)
    return unless files.any?

    ApplicationController.render( partial: 'shared/image_for_bc', locals: { files: files } )
  end
end
