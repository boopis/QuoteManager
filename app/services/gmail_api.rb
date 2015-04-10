# Gmail API services class 
# Send email by user account
class GmailAPI
  def initialize(token)
    @client = Google::APIClient.new
    @client.authorization.access_token = token
    @gmail = @client.discovered_api('gmail')
  end

  def send_message(msg)
    @email = @client.execute(
      api_method: @gmail.users.messages.to_h['gmail.users.messages.send'],
      body_object: {
        raw: Base64.urlsafe_encode64(msg.to_s)
      },
      parameters: {
        userId: 'me',
      }
    ) 
  end
end
