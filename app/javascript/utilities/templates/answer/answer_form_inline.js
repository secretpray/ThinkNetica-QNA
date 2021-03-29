// created_comment group 
export { inlineEditSection }

function inlineEditSection(data, answerDiv) {
  var generateNumber = new Date().getTime()
  const divFormInline = document.createElement('div')
  divFormInline.className = 'hide'
  divFormInline.id = `jumbotron-form-inline-${data.id}`
  const formInline = document.createElement('form')
  formInline.className = "simple_form form-inline m-3"
  formInline.id = `form-answer-${data.id}`
  formInline.setAttribute('novalidate', 'novalidate')
  formInline.setAttribute('enctype', 'multipart/form-data')
  formInline.setAttribute('action', `/answers/${data.id}`)
  formInline.setAttribute('accept-charset', "UTF-8")
  formInline.setAttribute('data-remote', "true")
  formInline.setAttribute('method', "post")
  formInline.innerHTML = `<input type="hidden" name="_method" value="patch" />
                          <div class="answer-error-${data.id}" id="errors-inline-answer"></div>
                          <textarea class="form-control mt-2" name="answer[body]" id="answer_body">${data.answer_body}</textarea>
                          <legend class="mt-3 fs-5">Links</legend>`
  formInline.innerHTML +=`<a
                            class="add_fields"
                            data-id="${generateNumber}"
                            data-fields='<div class="nested-fields" id="link-form-">
                            <input type="hidden" value="false" name="answer[links_attributes][${generateNumber}][_destroy]" id="answer_links_attributes_${generateNumber}__destroy" /><Name>
                            <div class="form-group string optional answer_links_name">
                            <input class="form-control string optional form-control" placeholder="Name" type="text" name="answer[links_attributes][${generateNumber}][name]" id="answer_links_attributes_${generateNumber}_name" />
                            </div></Name><URL><div class="form-group url optional answer_links_url"><input class="form-control string url optional form-control mt-2" placeholder="URL" type="url" name="answer[links_attributes][${generateNumber}][url]" id="answer_links_attributes_${generateNumber}_url" />
                            </div></URL><a class="remove_fields" href="#">Remove link</a></div>'
                            href="#"
                          >
                            Add Links...
                          </a>`
  formInline.innerHTML += `<input multiple="multiple" class="form-control" placeholder="Add files..." type="file" name="answer[files][]" id="answer_files" />
                          <input type="submit" name="commit" value="Update" class="btn btn-primary my-3 mx-2" data-disable-with="Update" />
                          <button class="btn btn-warning my-3" id="cancel-edit-${data.id}"><a data-remote="true" href="#">Cancel</a></button>
                          </form>`
  divFormInline.append(formInline)
  answerDiv.append(divFormInline)
  return answerDiv
}