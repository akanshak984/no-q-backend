# frozen_string_literal: true

class WhatsappController < V1::BaseController
  skip_before_action :authenticate!

  def receive
    return true if %w[user-event message-event].include?(params['type'])

    @config = ParseYml.load_config('no_q')
    NoQ::Initialize.new(
      config: @config,
      params: params
    ).call
  end
end
