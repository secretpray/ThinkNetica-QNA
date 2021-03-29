// set best answer module
export { setBest }

function setBest(data) { 
  var bestAnswer = {}
  bestAnswer = document.querySelector('.answer_' + data.id)
  
  var bestRewards = {}
  bestRewards = document.querySelectorAll('.best-section')
  // Remove all Best badge
  if (bestRewards.length) {
    bestRewards.forEach(function(element) { 
      element.remove()
    })
  }

  var bestList = {}
  bestList = document.querySelectorAll('.sortList')
  // Remove all Best class
  if (bestList.length) {
    bestList.forEach(function(element) { 
      element.classList.remove('best')
    })
  }

  // SetUp best class
  bestAnswer.classList.add('best')
  
  // Add badge
  if (data.is_best && data.badge_is_attached ) {
    const parentBadge = document.querySelector(`#answer-info_${data.id}`)
    const badgeDiv = document.createElement('div')
    badgeDiv.className = "best-section d-flex justify-content-end"
    const badgeImage = document.createElement('img')
    badgeImage.setAttribute('alt', 'Reward')
    badgeImage.className = "reward-image"
    badgeImage.setAttribute('src', `${data.reward_badge_image_link}`)
    badgeImage.setAttribute('width', "32")
    badgeImage.setAttribute('height', "32")
    const badgeSpan = document.createElement('span')
    badgeSpan.innerHTML = '<i class="text-warning">The best answer</i><span></span></span>'
    badgeDiv.append(badgeImage)
    badgeDiv.append(badgeSpan)
    parentBadge.append(badgeDiv)
  }
  
  // ReSort element by id
  function sortDivs(div) {
    var divs = document.querySelectorAll('.sortList');
    for (var i = 0, iLen = divs.length, a = []; i<iLen; i++) a[i] = divs[i]; // Convert divs collection to an array
    a.sort(function(a, b) {
      return a.id.split('_')[1] - b.id.split('_')[1]; 
    });
    while (iLen--) div.insertBefore(a[iLen], div.firstChild); // Move elements to sorted order
  }

  sortDivs(document.querySelector('.list-answers'));
  document.querySelector('.list-answers').prepend(bestAnswer)
  }
