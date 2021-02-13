// ---------- Vanila JS without Observer!!! -------------------
function voteSuccess(event) {
  const [{ id, type, rating, row_html }] = event.detail;
  const errorSection = document.querySelector(`.vote-errors-${type}_${id}`)
  if (errorSection.classList.contains('d-flex')) {
    errorSection.classList.replace('d-flex', 'd-none')
  }
  errorSection.innerText = ''
  const sectionVote = document.querySelector(`.vote_content-${type}_${id}`)
  console.log(`sectionVote: ${sectionVote}`)
  sectionVote.innerHTML = '';
  sectionVote.insertAdjacentHTML('beforeend', row_html );
  voteIterator()
}

function voteError(event) {
  const [{ id, type, error }] = event.detail;
  const errorSection = document.querySelector(`.vote-errors-${type}_${id}`)
  typeUpper = type.charAt(0).toUpperCase() + type.substring(1)
  errorSection.innerText = ''
  if (errorSection.classList.contains('d-none')) {
    errorSection.classList.replace('d-none', 'd-flex')
  }
  errorSection.insertAdjacentHTML("beforeend", `<p>${typeUpper} voted error: ${error}</p>`);
}

function voteIterator() {
  const questionContent = document.querySelector('#question_content')
  
  if (questionContent) {
    const voteElements = document.querySelectorAll('.upvote, .downvote, .reset')
  
    voteElements.forEach(voteElement => {
      voteElement.addEventListener("ajax:success", voteSuccess) 
      voteElement.addEventListener("ajax:error", voteError) 
    })
  }
}

document.addEventListener('turbolinks:load', voteIterator)