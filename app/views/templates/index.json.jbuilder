json.array!(@templates) do |template|
  json.extract! template, :id, :name, :content, :description, :account_id
  json.url template_url(template, format: :json)
end
