# frozen_string_literal: true

require 'listen'

require_relative 'yard2rbs/converter'
require_relative 'yard2rbs/yard_parser'
require_relative 'yard2rbs/version'

module Yard2rbs
  class << self
    # @param file_paths [Array<String>]
    # @return [Boolean]
    def convert(file_paths)
      file_paths.each do |file_path|
        output = Converter.convert(file_path)
        next if output.empty?

        output_path = sig_path_for(file_path)
        output_dirname = File.dirname(output_path)

        FileUtils.mkdir_p(output_dirname)
        File.open(output_path, 'w+') do |file|
          file.puts(output)
        end
      end

      true
    end

    # @param dir_paths [Array<String>]
    # @return [void]
    def watch(dir_paths)
      listener = Listen.to(
        *dir_paths,
        relative: true,
        only: /\.rb$/
      ) do |modified, added, removed|
        convert(added + modified)

        removed.each do |file_path|
          output_path = sig_path_for(file_path)
          next unless File.exist?(output_path)

          File.delete(output_path)
        end
      end
      listener.start
      sleep
    end

    private

    # @param file_path [String]
    # @return [String]
    def sig_path_for(file_path)
      input_dirname = File.dirname(file_path)
      input_filename = File.basename(file_path, '.*')

      output_dirname = File.join('sig', input_dirname)
      output_filename = "#{input_filename}.rbs"
      File.join(output_dirname, output_filename)
    end
  end
end
