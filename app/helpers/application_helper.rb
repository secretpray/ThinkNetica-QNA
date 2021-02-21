module ApplicationHelper

  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: "card border-danger", id: "errors-content") do
        concat(content_tag(:div, class: "card-header bg-danger text-white") do
          concat "#{pluralize(object.errors.count, "error")} prohibited this #{object.class.name.downcase} from being saved:"
        end)
        concat(content_tag(:div, class: "card-body") do
          concat(content_tag(:ul, class: 'mb-0') do
            object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end

  # create new link fields
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render('shared/' + association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

    # return clear gist ids 
    def parse_gist_id(link_url)
      gist_id = 
        if link_url.match? '</script>'
          link_url.sub(/.js"><\/script>/, '')
        elsif link_url.match? '.git'
          link_url.sub(/.git$/, '')
        else
          link_url
        end
        File.basename(gist_id)
    end

    def set_path(resource)
      if resource.is_a?(Answer)
        resource_path = resource.question, resource
      else
        resource_path = resource
      end
    end

    def ident(resource)
      resource.class.to_s.downcase
    end
end
