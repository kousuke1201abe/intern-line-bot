require 'line/bot'

class LineWebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def callback
    LineBotClient.new(request_body: request.body.read, signature: request.env['HTTP_X_LINE_SIGNATURE']).call ? head(:ok) : head(470)
  end
end
