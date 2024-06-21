# frozen_string_literal: true

require_relative "yard2rbs/converter"
require_relative "yard2rbs/yard_parser"
require_relative "yard2rbs/version"

module Yard2rbs
  class << self
    # @param file_paths [Array<String>]
    # @return [Boolean]
    def convert(file_paths)
      file_paths.each do |file_path|
        output = Converter.new(file_path).convert
        next if output.empty?

        input_dirname = File.dirname(file_path)
        input_filename = File.basename(file_path, ".*")

        output_dirname = File.join("sig", input_dirname)
        output_filename = "#{input_filename}.rbs"
        output_path = File.join(output_dirname, output_filename)

        FileUtils.mkdir_p(output_dirname)
        File.open(output_path, 'w+') do |file|
          file.puts(output)
        end
      end

      true
    end
  end
end
