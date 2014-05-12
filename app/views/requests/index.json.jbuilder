json.array!(@requests) do |request|
  json.extract! request, :id, :fields, :form_id
  json.url request_url(request, format: :json)
end
