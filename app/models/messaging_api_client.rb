class MessagingAPIClient < Line::Bot::Client
  attr_reader :request

  def initialize(request:, &block)
    super(&block)
    @request = request
  end

  def reply
    build_reply_messages if signatured?
  end

  private

  def signatured?
    validate_signature(
      request.body.read,
      request.env['HTTP_X_LINE_SIGNATURE'],
    )
  end

  def build_reply_messages
    parse_events_from(request.body.read).each do |event|
      return true unless event.is_a?(Line::Bot::Event::Message)
      return true unless event.type == "text"

      if event.message['text'].split.first.downcase == "wikipedia"
        event.message['text'] = WikipediaAPIClient.new(query: event.message['text'].split(' ', 2).last).search_text
      end

      haiku = HaikuGenerator.generate(phrase: event.message['text'])

      reply_message(
        event['replyToken'],
        {
          type: 'text',
          text: MatsuoBasho.new(haiku).reply_message
        }
      )
    end
  end
end
