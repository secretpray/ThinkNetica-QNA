// created comment
export { commentCreate }

function commentCreate(data, dateAgo) {
  const commentsList = document.getElementById(`${data.resource_name}-comments-${data.resource_id}`)
  const commentNewDiv = document.createElement('div'); 
  commentNewDiv.className = "comment offset-1 p-3"
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
}