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

      matsuo_basho = MatsuoBasho.new(phrase: event.message['text'])

      if matsuo_basho.haiku?
        reply_message(event['replyToken'], matsuo_basho.message(:haiku))
      elsif matsuo_basho.senryu?
        reply_message(event['replyToken'], matsuo_basho.message(:senryu))
      elsif matsuo_basho.tanka?
        reply_message(event['replyToken'], matsuo_basho.message(:tanka))
      end
    end
  end
end
