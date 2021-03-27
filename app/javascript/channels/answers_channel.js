import consumer from "./consumer"
import { parseDate } from '../utilities/parse_data'
import { buttonGroup } from '../utilities/templates/answer/button_group'
import { inlineEditSection } from '../utilities/templates/answer/answer_form_inline'
import { commentGroup } from '../utilities/templates/answer/answer_comments'
import { setBest } from '../utilities/templates/answer/answer_set_best'
import { parseUrl } from '../utilities/parse_gist_url'

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
          setBest(`${data.id}`)
          this.perform("update_online_status")
        } else if (data.action === 'create' && gon.user_id != data.author_id) {
          const dateAgoCreated = parseDate(data.created_at)
          const dateAgoUpdated = parseDate(data.updated_at)
          const answersCount = document.querySelector('.answers_count')
          const answerSection = document.querySelector('.list-answers')
          const answerDiv = document.createElement('div');
          answerDiv.className = `card sortList mt-2 answer_${data.id} edited`
          answerDiv.id = `answerBlock_${data.id}`
          const answerJumbo = document.createElement('div');
          answerJumbo.className = 'card-body'
          answerJumbo.id = `jumbotron-${data.id}`
          const answerLi = document.createElement('li')
          answerLi.className = "checkedBest p10 fs-5 grey"
          answerLi.innerText = `${data.answer_body}`
          answerJumbo.append(answerLi)
          // answerJumbo.innerHTML = `<li class="checkedBest p10 fs-5 grey">${data.answer_body}</li>`
          answerDiv.append(answerJumbo)
          // Vote section
          const voteContent = document.createElement('div');
          voteContent.className = `vote_content-answer_${data.id}`
          voteContent.innerHTML = `<div class="vote-answer_${data.id} d-flex justify-content-between">
                                  <div class="vote-info d-flex justify-content-end mt-3 mb-2">
                                  <span class="votes-answer_${data.id}-total votes-total">Rating: 0</span></div></div>`
          const voteErrors = document.createElement('div');
          voteErrors.className = `vote-errors-answer_${data.id} justify-content-center text-danger py-1 d-none`
          voteContent.append(voteErrors)
          answerJumbo.append(voteContent)
          // Info section
          const infoContent = document.createElement('div');
          infoContent.className = 'fz14'
          infoContent.id = `answer-info_${data.id}`
          infoContent.innerHTML = `<div class="info-section d-flex justify-content-start">
                                  Submitted&nbsp;<strong>${dateAgoCreated}</strong>
                                  &nbsp;ago, by&nbsp;
                                  <span class="activity-status user-${userId}-status online" data-user-id="${userId}">sss@mail.com</span>;
                                  &nbsp;Last updated:&nbsp;
                                  <strong>${dateAgoUpdated}</strong></div></div>`
          answerJumbo.append(infoContent)
          // Add links
          if (data.links.length) {
            const linksDiv = document.createElement('ul')
            linksDiv.className = `"answer-link_${data.id}">`
            data.links.forEach((link) => {
              var blockLink = document.createElement('li')
              blockLink.id = `link_${link.id}`
              var regex = /https*:\/\/gist.github.com\/\w+/
              var url = link.url
              var gistId = parseUrl(url)
              console.log(`link.url: ${url}`)
              if (url.match(regex)) {
                const innerDiv = document.createElement('div')
                innerDiv.className = "pb-2 pt-3 pr-1 d-flex justify-content-between"
                const linkContentDiv = document.createElement('div')
                linkContentDiv.className = "link-content"
                linkContentDiv.innerText = link.name
                linkContentDiv.innerHTML += '<button class="btn btn-outline-light mx-2 gist-button" style="background: darkgray;">Show gist</button>'
                const linkContentHide = document.createElement('div')
                linkContentHide.className = "hide"
                linkContentHide.setAttribute('data-gistlink-id', `${data.id}`)
                linkContentHide.setAttribute('data-src-id', `${gistId}`)
                linkContentHide.id = "gist_link"
                linkContentHide.innerHTML = `<div id="gistFrame">${link.url}</div>`
                const linkDelete = document.createElement('div')
                linkDelete.className = "link-delete"
                linkDelete.innerHTML = `<a data-remote="true" rel="nofollow" data-method="delete" href="/links/${data.id}">Delete Link</a>`
                linkContentDiv.append(linkContentHide)
                innerDiv.append(linkContentDiv)
                innerDiv.append(linkDelete)
                blockLink.append(innerDiv)
              } else {
                blockLink.innerHTML = `<div class="pb-2 pt-3 pr-1 d-flex justify-content-between"><a href="${link.url}">${link.name}</a>
                                      <a data-remote="true" rel="nofollow" data-method="delete" href="/links/${link.id}">Delete Link</a></div>`
              }
              linksDiv.append(blockLink);
            });
            const legendLink = document.createElement('h6')
            legendLink.innerText = 'Links:'
            answerJumbo.append(legendLink);
            answerJumbo.append(linksDiv);
          }
          // Add button 'Best' or Edit/Delete/Best
          buttonGroup(`${data.id}`, answerJumbo)
          if (gon.is_admin) { inlineEditSection(data, answerDiv) } // Add inline form edit
          // add <hr> before comments section
          answerDiv.append(document.createElement('hr'))
          // Add comment section
          commentGroup(`${data.question_id}`, `${data.id}`, answerDiv)
          // Add full answer section to answers list
          answerSection.append(answerDiv)
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
