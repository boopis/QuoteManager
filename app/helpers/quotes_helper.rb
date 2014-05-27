module QuotesHelper
  def link_to_add_terms(name, f, association)
    new_object = OpenStruct.new(@qb.terms)
    id = new_object.object_id
    terms = f.fields_for(association, new_object, index: id) do |builder|
      render('terms', f: builder)
    end
    link_to(' Add Terms', '#', class: "add_terms pull-right fa fa-plus-circle", data: {id: id, terms: terms.gsub("\n", "")})
  end
end