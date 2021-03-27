// created_button grpup for admin
export { buttonGroup }
function buttonGroup(id, answerJumbo) {
  const buttonGroup = document.createElement('div');
  buttonGroup.id = 'button-inline'
  buttonGroup.className = "button-group"
  const buttonEdit = document.createElement('button');
  buttonEdit.id = `button-edit-answer-${id}`
  buttonEdit.className = "edit-answer"
  buttonEdit.innerHTML = `<a class="edit-answer-link" data-answer-id="${id}" data-remote="true" href="http://${document.location.host}/answers/${id}/edit">Edit</a>`
  const buttonDelete = document.createElement('button');
  buttonDelete.id = `button-delete-answer-${id}`
  buttonDelete.className = "delete-answer"
  buttonDelete.innerHTML = `<a data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="http://${document.location.host}/answers/${id}">Delete</a>`
  const buttonBest = document.createElement('button');
  buttonBest.id = `button-best-answer-${id}`
  buttonBest.className = "best-answer"
  buttonBest.innerHTML = `<a data-remote="true" rel="nofollow" data-method="patch" href="http://${document.location.host}/answers/${id}/best">✓ Best</a>`
  if (gon.is_admin) { buttonGroup.append(buttonEdit) }
  if (gon.is_admin) { buttonGroup.append(buttonDelete) }
  buttonGroup.append(buttonBest)
  answerJumbo.append(buttonGroup)
}