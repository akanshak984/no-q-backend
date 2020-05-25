# frozen_string_literal: true

class ImageReader
  class << self
    def read_text(file_name)
      path = Rails.root.join('public', file_name).to_path
      image = RTesseract.new(path)
      image.to_s.split(' ')
    rescue StandardError
      nil
    end
  end
end