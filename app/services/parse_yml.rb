# frozen_string_literal: true

class ParseYml
  class << self
    def load_config(file_name)
      json_data = YAML.load_file('config/whatsapp/' + file_name + '.yml').to_json
      JSON.parse(json_data, object_class: OpenStruct).send(file_name.to_sym)
    rescue StandardError
      nil
    end
  end
end
