module FormsHelper
  def link_to_add_fields(name, type, icon, f, association)
    new_object = OpenStruct.new(@fb.fields)
    id = new_object.object_id
    fields = f.fields_for(association, new_object, index: id) do |builder|
      render(type, f: builder)
    end
    link_to("#", class: "list-group-item add_fields", data: {fields: fields.gsub("\n", "")}) do
      content_tag(:i, name, class: icon)
    end
  end

  def link_to_add_options(name, f, association)
    fields = f.fields_for(association, index: "") do |builder|  
      render(name, f: builder)  
    end  
    link_to('Add Options', '#', class: "add_options btn btn-primary", data: {fields: fields.gsub("\n", "")})
  end
end
