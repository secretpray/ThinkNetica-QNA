import consumer from "./consumer"
import { parseDate } from '../utilities/parse_data'

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
        // commentsList.insertAdjacentHTML("afterbegin", data.html);
        const dateAgo = parseDate(data.created_at)
        const commentsList = document.getElementById(`${data.resource_name}-comments-${data.resource_id}`)
        const commentNewDiv = document.createElement('div'); 
        commentNewDiv.className = "comment offset-1"
        commentNewDiv.id = `comment_${data.comment_id}`
        const commentContent = document.createElement('p');
        commentContent.className = "fz18"
        commentContent.innerHTML = `${data.body}`
        const commentInfo = document.createElement('div');
        commentInfo.className = "fz14 pb-3 d-flex justify-content-between"
        commentInfo.id = `comment-info_${data.comment_id}`
        const commentInfoChild = document.createElement('div');
        commentInfoChild.className = "comment-info-section d-flex justify-content-start"
        commentInfoChild.innerHTML = `Created:&nbsp;<strong>${dateAgo}</strong>&nbsp;ago, by&nbsp;<span class="activity-status user-${data.author_id}-status" data-user-id="${data.author_id}">${data.email}</span>`
        commentInfo.append(commentInfoChild);
        if (gon.user_id && gon.is_admin) {
          const buttonDeleteComment = document.createElement('div');
          buttonDeleteComment.className = 'spam-delete delete_comment_answer_path'
          buttonDeleteComment.innerHTML = `<a data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/${data.resource_name}s/${data.comment_id}/delete_comment">Delete</a>`;
          commentInfo.append(buttonDeleteComment);
        }
        commentNewDiv.append(commentContent);
        commentNewDiv.append(commentInfo);
        commentNewDiv.innerHTML += '<hr />'
        commentNewDiv.innerHTML += '<br />'
        commentsList.append(commentNewDiv)
        
        // Update online status for created comment. 
        this.perform('update_online_status')
        }
      }
    })
  }
})