// created_comment group 
export { commentGroup }

function commentGroup(question_id, id, answerDiv) {
  const commentsList = document.createElement('div')
  commentsList.className = "answer-comments m-4"
  commentsList.innerHTML = `<h6>Answer comment(s):</h6>
                            <div class="comments_list pt-2" id="answer-comments-${id}"></div>
                            <a class="add-comment-link btn btn-link mt-3" style="background: ghostwhite;" \
                            href="http://${document.location.host}/questions/${question_id}#">Add comment</a>`
  const divForm  = document.createElement('div')
  divForm.className = "comment-form mt-3 d-none"
  const commentForm = document.createElement('form')
  commentForm.id = `comments-answer_${id}`
  commentForm.className = "simple_form new_comment"
  commentForm.setAttribute('novalidate', 'novalidate')
  commentForm.setAttribute('action', `/answers/${id}/create_comment`)
  commentForm.setAttribute('accept-charset', "UTF-8")
  commentForm.setAttribute('data-remote', "true")
  commentForm.setAttribute('method', "post")
  commentForm.innerHTML =  `<div class="comments-error-answer_${id}" id="errors-inline-comments"></div>
                            <div class="form-group pt-2" id="comments-form-answer_${id}">
                              <div class="form-group text required comment_body">
                                <label class="text required" for="comment_body">Body <abbr title="required">*</abbr></label>
                                <textarea class="form-control text required" placeholder="Add your comment..." name="comment[body]" id="comment_body"></textarea>
                              </div>
                            </div>
                            <div class="form-group pb-3"><input type="submit" name="commit" value="Create" class="btn btn btn-secondary mt-2 mb-3" data-disable-with="Create" /></div>`
  
  divForm.append(commentForm)
  commentsList.append(divForm)
  answerDiv.append(commentsList)
  return answerDiv
}