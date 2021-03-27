document.addEventListener('turbolinks:load', function() {

  // Hide/Show new comments form
  document.body.addEventListener("click", function (event) {
    if (event.target.classList.contains('add-comment-link')) {
    const buttonComment = event.target 
    event.preventDefault();
    const sectionCommentForm = buttonComment.nextElementSibling
    if (sectionCommentForm.classList.contains('d-none')) {
      sectionCommentForm.classList.remove('d-none')
      buttonComment.innerText = 'Hide comment'
      } else {
      sectionCommentForm.classList.add('d-none')
      buttonComment.innerText = 'Add comment'
      }
    }
  })
})