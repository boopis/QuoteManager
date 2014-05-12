json.array!(@quotes) do |quote|
  json.extract! quote, :id, :amount, :terms, :token, :expires_at, :request_id
  json.url quote_url(quote, format: :json)
end
