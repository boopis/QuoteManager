module QuotesHelper
  def link_to_add_quote_options(name, f, association)
    new_object = OpenStruct.new(@qb.options)
    id = new_object.object_id
    options = f.fields_for(association, new_object, index: id) do |builder|
      render('options', f: builder)
    end
    link_to(' Add Options', '#', class: "add_quote_options pull-right fa fa-plus-circle", data: {id: id, options: options.gsub("\n", "")})
  end
end