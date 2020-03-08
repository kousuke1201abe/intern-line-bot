require 'line/bot'

class LineWebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def callback
    messaging_api_client.reply ? head(:ok) : head(470)
  end

  private

  def messaging_api_client
    @messaging_api_client ||= MessagingAPIClient.new(request: request) do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end
end
