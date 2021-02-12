// ----------------- With Observer  -----------------------------
// document.addEventListener('turbolinks:load', () => {
//   const questionContent = document.querySelector('#question_content')
  
//   const observer = new MutationObserver(function() {
//     const voteElements = document.querySelectorAll('.upvote, .downvote, .reset')
   
//     for (let i = 0; i < voteElements.length; i++) { 
//       voteElements[i].addEventListener("ajax:success", voteSuccess) 
//       voteElements[i].addEventListener("ajax:error", voteError) 
//     }
       
//     function voteSuccess(event) {
//       const { id, type, rating, row_html } = event.detail[0];
//       const errorSection = this.parentNode.parentNode.nextSibling
//       if (errorSection) { 
//         errorSection.innerText = ''
//         if (errorSection.classList.contains('d-flex')) {
//           errorSection.classList.replace('d-flex', 'd-none')
//         }
//       }
//       const sectionVote = this.parentNode.parentNode.parentNode
//       if (sectionVote) { 
//         sectionVote.innerHTML = ''
//         sectionVote.insertAdjacentHTML('beforeend', row_html );
//       }
//     }

//     function voteError(event) {
//       const errorSection = this.parentNode.parentNode.nextSibling
//       const { id, type, error } = event.detail[0];
//       typeUpper = type.charAt(0).toUpperCase() + type.substring(1)
//       if (errorSection) { 
//         errorSection.innerText = ''
//         if (errorSection.classList.contains('d-none')) {
//           errorSection.classList.replace('d-none', 'd-flex')
//         }
//         errorSection.insertAdjacentHTML("beforeend", `<p>${typeUpper} voted error: ${error}</p>`);
//       }
//     }
//   });

//   if (questionContent) {
//     observer.observe(questionContent, {childList: true, subtree: true });
//   }
// })

// ---------- Without Observer!!!  -------------------
function voteSuccess(event) {
  const [{ id, type, rating, row_html }] = event.detail;
  // const { id, type, rating, row_html } = event.detail[0];
  const errorSection = this.parentNode.parentNode.nextSibling
  errorSection.innerText = ''
  if (errorSection.classList.contains('d-flex')) {
    errorSection.classList.replace('d-flex', 'd-none')
  }
  const sectionVote = this.parentNode.parentNode.parentNode
  sectionVote.innerHTML = '';
  sectionVote.insertAdjacentHTML('beforeend', row_html );
  voteIterator()
}

function voteError(event) {
  const errorSection = this.parentNode.parentNode.nextSibling
  const [{ id, type, error }] = event.detail;
  // const { id, type, error } = event.detail[0];
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
  
    for (let i = 0; i < voteElements.length; i++) { 
      voteElements[i].addEventListener("ajax:success", voteSuccess) 
      voteElements[i].addEventListener("ajax:error", voteError) 
    }
  }
}

document.addEventListener('turbolinks:load', voteIterator)