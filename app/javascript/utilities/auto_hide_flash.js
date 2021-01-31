document.addEventListener('turbolinks:load', function() {
 
  // Dismiss alert flash (button close)
  const flashList = document.querySelector('.alert')

  if (flashList) {
    flashList.addEventListener("click", (event) => {
      flashList.remove()
    });
  }

   // Timeout autohide flash notice
  const notice = document.getElementById('flash-notice');
  if (notice) fadeOut(notice)

  // Timeout autohide flash alert
  const alert = document.getElementById('flash-alert');
  if (alert) fadeOut(alert)

  // Timeout autohide Devise error
  const deviseErrorExplanation = document.getElementById('error_explanation');
  if (deviseErrorExplanation) fadeOut(deviseErrorExplanation)

  function fadeOut(object) {
    if (object) {
      object.classList.add('fadeout');
      window.setTimeout(function() {
        object.innerText = '';
        object.remove();
      }, 7000);
    }
  }

  // For inline errors only
  const answerObserver = document.querySelector("#errors-answer");

  const observer = new MutationObserver(function() {
    const inlineError = document.getElementById('errors-content')
    fadeOut(inlineError)
  });

  if (answerObserver) {
    observer.observe(answerObserver, {childList: true, subtree: true });
  }
})
