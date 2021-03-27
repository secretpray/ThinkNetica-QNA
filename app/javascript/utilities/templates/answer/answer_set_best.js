// set best answer module
export { setBest }

function setBest(id) { 
  var bestAnswer = {}
  bestAnswer = document.querySelector('.answer_' + id)
  console.log('bestAnswer', bestAnswer)
  var bestList = {}
  bestList = document.querySelectorAll('.sortList')
  
  if (bestList.length) {
    bestList.forEach(function(element) { 
      element.classList.remove('best')
    })
  }
  bestAnswer.classList.add('best')
  
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
