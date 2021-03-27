import consumer from "./consumer"
import { questionCreate } from '../utilities/templates/question/create_question'

document.addEventListener('turbolinks:load', () => {
  const elementController = document.querySelector('body')
  const controllerName = elementController.getAttribute('data-controller-name')
  const actionName = elementController.getAttribute('data-action-name')
  // window.subscriptions = consumer.subscriptions
  if (controllerName == 'questions' && actionName == 'index') {
    consumer.subscriptions.create("QuestionsChannel", {
      connected() {
      }, 
      received(data) {
        if (data.action === 'destroy' && gon.user_id != data.author_id) {
          var questionForDeleted = {}
          questionForDeleted = document.getElementById(`question_${data.id}`);
          if (questionForDeleted) { 
            questionForDeleted.remove() 
          }
        } else if (data.action === 'update_rating' && gon.user_id != data.author_id && data.type === 'question') {
          const spanRating = document.querySelector(`.votes-question_${data.id}-total`)
          if (spanRating) { spanRating.innerText = `Rating: ${data.rating}` }
        } else if (data.action === 'create' && gon.user_id != data.author_id ) {
          questionCreate(data)
        } else if (data.action == 'update_badge' && controllerName == 'questions' && actionName == 'index' ) {
          var questionInList = document.querySelector(`#question_${data.id} > span`)
          if (questionInList) { questionInList.innerText = data.answers_count }
        }
      }
    })
  }
})
