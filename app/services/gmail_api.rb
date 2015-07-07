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
        userId: 'me'
      }
    ) 
  end

  def get_list_message_id
    emails = nil
    next_page_token = nil
    # One request returns max 100 mails, so we iterate while there is a nextPageToken
    while !next_page_token.nil? || emails.nil?
      emails ||= []
      # Retrieve all unread mail in the current label
      emails_result = @client.execute(
        api_method: @gmail.users.messages.list,
        parameters: {
          userId: 'me',
          maxResults: 100,
          q: "is:unread",
          pageToken: next_page_token,
        }
      )
      result = JSON.load(emails_result.body)
      next_page_token = result['nextPageToken']
      emails.append(result['messages'].map { |x| x['id'] }) unless result['messages'].nil?
    end
    emails.flatten!
  end

  def get_message_by_id(id)
    res = @client.execute(
      api_method: @gmail.users.messages.get,
      parameters: {
        userId: 'me',
        id: id,
      }
    )
    data = JSON.parse(res.body)

    { 
      subject: self.get_attribute(data, 'Subject'),
      from: self.get_attribute(data, 'From'),
      body: data['parts']
    }
  end

  def get_attribute(data, attribute)
    header = data['payload']['headers']
    array = header.reject { |hash| hash['name'] != attribute }
    array.first['value']
  end
end
