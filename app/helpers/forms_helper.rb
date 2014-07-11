module FormsHelper
  def link_to_add_fields(name, type, icon, f, association)
    new_object = OpenStruct.new(@fb.fields)
    id = new_object.object_id
    fields = f.fields_for(association, new_object, index: id) do |builder|
      render(type, f: builder)
    end
    link_to("#", class: "list-group-item add_fields", data: {id: id, fields: fields.gsub("\n", "")}) do
      content_tag(:i, name, class: icon)
    end
  end

  def link_to_add_contact_fields(name, type, tid, icon, f, association, obj)
    new_object = OpenStruct.new(@fb.fields)
    id = new_object.object_id
    fields = f.fields_for(association, new_object, index: id) do |builder|
      render(type, f: builder)
    end
    link_to("#", class: "list-group-item #{contact_menu_active?(obj,type)}", id: tid, data: {id: id, fields: fields.gsub("\n", "")}) do
      content_tag(:i, name, class: icon)
    end
  end

  def contact_menu_active?(obj,key)
    if obj.fields? && obj.fields.detect{|k,v| v['type'] == key}
      'cant_add_fields'
    else
      'add_contact_fields'
    end
  end

  def link_to_add_options(name, f, association)
    fields = f.fields_for(association, index: "") do |builder|  
      render(name, f: builder)  
    end  
    link_to('Add Options', '#', class: "add_options fa fa-plus-circle", data: {fields: fields.gsub("\n", "")})
  end
end
