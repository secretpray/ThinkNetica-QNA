import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const elementController = document.querySelector('body')
  const controllerName = elementController.getAttribute('data-controller-name')
  const actionName = elementController.getAttribute('data-action-name')

  if (controllerName == 'questions' && actionName == 'show') {
    const questionId = +(document.querySelector('#question_content').getAttribute('data-channel-room'))
    consumer.subscriptions.create({channel: "ActivityChannel", question_id: questionId }, {
      connected() {
        // console.log('Connected to Activity channel')
        this.perform("appear")
      },
      disconnected() {        
      },
      received(data) {
        let elements = document.querySelectorAll('.activity-status');
        var onlineUserArray = data.list_online_users
        
        if (onlineUserArray) {
          console.log(`Online User id: ${onlineUserArray}, count: ${onlineUserArray.length}`)

          for (var i = 0; i < elements.length; i++) {
            if ( onlineUserArray.includes(elements[i].getAttribute('data-user-id')) ) {
              elements[i].classList.add('online')
            } else {
              elements[i].classList.remove('online')
            }
          }
        }
      }
    })
  }
})
