// created question in list group 
export { questionCreate }

function questionCreate(data) {
  var questionList = {}
  questionList = document.querySelector('.question_list')
  if (questionList) {
    const questionDiv = document.createElement('div');
    questionDiv.id = `question_${data.question.id}`
    questionDiv.className = "question content d-flex";
    const liQuestion = document.createElement('li');
    liQuestion.className = 'col-md-10 m-4 fs-5';
    liQuestion.innerHTML = `<a href="/questions/${data.question.id}">${data.question.title}</a>`;
    const badgeQuestion = document.createElement('span')// <span class="badge rounded-pill bg-secondary">0</span>
    badgeQuestion.className = 'badge rounded-pill bg-secondary'
    badgeQuestion.innerText = 0
    questionDiv.append(liQuestion);
    questionDiv.append(badgeQuestion);

    // realy need in frontend?
    if (gon.user_id && gon.is_admin) {
      const buttonEdit = document.createElement('button');
      buttonEdit.className = 'edit-question'
      buttonEdit.innerHTML = `<a href="/questions/${data.question.id}/edit">Edit</a>`;
      questionDiv.append(buttonEdit);
      const buttonDelete = document.createElement('button');
      buttonDelete.className = 'delete-question'
      buttonDelete.innerHTML = `<a data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="/questions/${data.question.id}">Delete</a>`;
      questionDiv.append(buttonDelete);
    }      
    questionList.prepend(questionDiv);
  }
}