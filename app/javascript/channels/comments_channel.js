import consumer from "./consumer"
import { parseDate } from '../utilities/parse_data'
import { commentCreate } from '../utilities/templates/comment/create_comment'

document.addEventListener('turbolinks:load', () => {
  const elementController = document.querySelector('body')
  const controllerName = elementController.getAttribute('data-controller-name')
  const actionName = elementController.getAttribute('data-action-name')

  if (controllerName == 'questions' && actionName == 'show') {
    const questionId = +(document.querySelector('#question_content').getAttribute('data-channel-room'))  
    consumer.subscriptions.create({channel: "CommentsChannel", question_id: questionId }, {
    connected() {
    }, 
    received(data) {
      if (data.action === 'destroy' && gon.user_id != data.author_id || data.action === 'destroy' && gon.user_id && !gon.is_admin ) {
        let comment = document.querySelector(`#comment_${data.id}`)
        if (comment) { comment.remove(); }
      } else if (data.action === 'create' && gon.user_id != data.author_id) {
        const dateAgo = parseDate(data.created_at)
        
        // Create comment
        commentCreate(data, dateAgo)
        
        // Update online status for created comment. 
        this.perform('update_online_status')
        }
      }
    })
  }
})