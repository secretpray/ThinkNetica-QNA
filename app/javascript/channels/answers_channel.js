import consumer from "./consumer"
import { parseDate } from '../utilities/parse_data'
import { setBest } from '../utilities/templates/answer/answer_set_best'
import { createAnswer } from '../utilities/templates/answer/answer_create'
// import { parseUrl } from '../utilities/parse_gist_url'
// import { buttonGroup } from '../utilities/templates/answer/button_group'
// import { inlineEditSection } from '../utilities/templates/answer/answer_form_inline'
// import { commentGroup } from '../utilities/templates/answer/answer_comments'


document.addEventListener('turbolinks:load', () => {
  const elementController = document.querySelector('body')
  const controllerName = elementController.getAttribute('data-controller-name')
  const actionName = elementController.getAttribute('data-action-name')
  const userId = elementController.getAttribute('data-user-id')
  // window.subscriptions = consumer.subscriptions
  
  if (controllerName == 'questions' && actionName == 'show') {
    const questionId = +(document.querySelector('#question_content').getAttribute('data-channel-room'))

    consumer.subscriptions.create({channel: "AnswersChannel", question_id: questionId }, {
      connected() {
      }, 
      received(data) {
        //if (data.action === 'destroy' && gon.user_id != data.author_id || data.action === 'destroy' && gon.user_id && !gon.is_admin ) {
        if (data.action === 'destroy' && gon.user_id != data.author_id ) {
          const answerDelete = document.querySelector(`.answer_${data.id}`)
          const answersCount = document.querySelector('.answers_count')
          if (answerDelete) { 
            answerDelete.remove() 
            answersCount.innerHTML = `<strong> ${data.answers_count}&nbsp;Answers</strong>`
          }
        } else if (data.action === 'update_rating' && gon.user_id != data.author_id) {
          if ( data.type === 'answer' ) { const spanAnswerRating = document.querySelector(`.votes-answer_${data.id}-total`)
            if ( spanAnswerRating ) { spanAnswerRating.innerText = `Rating: ${data.rating}`}
          } else if ( data.type === 'question' ) { const spanQuestionRating = document.querySelector(`.votes-question_${data.id}-total`)
            if ( spanQuestionRating ) { spanQuestionRating.innerText = `Rating: ${data.rating}` }
          }
        } else if (data.action === 'set_best' && gon.user_id != data.author_id) {
          //} else if (data.action === 'set_best' && gon.user_id === data.author_id || data.action === 'set_best' && gon.is_admin ) {
          setBest(data)
          this.perform("update_online_status")
        } else if (data.action === 'create' && gon.user_id != data.author_id) {
          const dateAgoCreated = parseDate(data.created_at)
          const dateAgoUpdated = parseDate(data.updated_at)
          const answersCount = document.querySelector('.answers_count')
          
          //Create answer
          createAnswer(data, dateAgoCreated, dateAgoUpdated, userId)
          
          // Update answers couter
          answersCount.innerHTML = `<strong> ${data.answers_count}&nbsp;Answers</strong>`
          
          // Update online status for new answer
          this.perform("update_online_status")
        } else if ( data.action === 'delete_question' && document.location.origin + `/question/${data.id}`) { 
          document.location.replace(origin)
        } 
      }
    })
  }
})
