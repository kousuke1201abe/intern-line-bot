class LineBotClient
  attr_reader :request_body, :signature

  def initialize(request_body:, signature:)
    @request_body = request_body
    @signature = signature
  end

  def call
    return false unless validate

    client.parse_events_from(request_body).each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          matsuo_basho = MatsuoBasho.new(phrase: event.message['text'])
          if matsuo_basho.haiku?
            client.reply_message(event['replyToken'], matsuo_basho.message(:haiku))
          elsif matsuo_basho.tanka?
            client.reply_message(event['replyToken'], matsuo_basho.message(:tanka))
          end
        end
      end
    end
  end

  private

  def validate
    client.validate_signature(request_body, signature)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end
end
