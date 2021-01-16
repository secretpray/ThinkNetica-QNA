document.addEventListener('turbolinks:load', function() {
   // Timeout autohide flash notice
  const notice = document.getElementById('flash-notice');
  if (notice) fadeOut(notice, 5000)

  // Timeout autohide flash alert
  const alert = document.getElementById('flash-alert');
  if (alert) fadeOut(alert, 7000)

  // Timeout autohide Devise error
  const deviseErrorExplanation = document.getElementById('error_explanation');
  if (deviseErrorExplanation) fadeOut(deviseErrorExplanation, 7000)

  function fadeOut(object, time) {
    window.setTimeout(function() {
      object.classList.add('fade-out')
    }, time);
  }
})
