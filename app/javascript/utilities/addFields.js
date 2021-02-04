class addFields {
    constructor() {
      this.links = document.querySelectorAll('.add_fields')
      this.iterateLinks()
    }
  
    iterateLinks() {
      // If there are no links on the page, stop the function from executing.
      if (this.links.length === 0) return
      // Loop over each link on the page. A page could have multiple nested forms.
      this.links.forEach(link => {
        link.addEventListener('click', e => {
          this.handleClick(link, e)
        })
      })
    }
  
    handleClick(link, e) {
      if (!link || !e) return
      e.preventDefault()
      // Save a unique timestamp to ensure the key of the associated array is unique.
      let time = new Date().getTime()
      let linkId = link.dataset.id
      let regexp = linkId ? new RegExp(linkId, 'g') : null
      // Replace all instances of the `new_object.object_id` with `time`, and save markup into a variable if there's a value in `regexp`.
      let newFields = regexp ? link.dataset.fields.replace(regexp, time) : null
      newFields ? link.insertAdjacentHTML('beforebegin', newFields) : null
    }
  }
  
  window.addEventListener('turbolinks:load', () => new addFields())