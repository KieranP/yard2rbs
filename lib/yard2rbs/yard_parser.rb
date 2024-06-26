# frozen_string_literal: true

# TODO:
# * Convert YARD "Boolean" to RBS "bool"
# * Make some classes top level via :: (e.g. String -> ::String)

module Yard2rbs
  class YardParser
    class << self
      # @param comments [Array<String>]
      # @return [Hash<Symbol, Array<String> | Hash<String, String>>]
      def parse(comments)
        params = {}
        returns = []

        yieldparams = {}
        yieldreturns = []

        comments&.each do |comment|
          case comment
          when /@param/
            if matches = comment.match(/# @param ([^\s]+) \[([^\]]+)\].*/)
              params[matches[1]] = convert(matches[2])
            end

          when /@return/
            if matches = comment.match(/# @return \[([^\]]+)\].*/)
              returns += convert(matches[1])
            end

          when /@yieldparam/
            if matches = comment.match(/# @yieldparam ([^\s]+) \[([^\]]+)\].*/)
              yieldparams[matches[1]] = convert(matches[2])
            end

          when /@yieldreturn/
            if matches = comment.match(/# @yieldreturn \[([^\]]+)\].*/)
              yieldreturns += convert(matches[1])
            end
          end
        end

        {
          params:,
          returns:,

          yieldparams:,
          yieldreturns:,
        }
      end

      # Converts YARD type string into RBS type array
      # e.g. Input:  "String, Array<String>, Hash<String, String>"
      #      Output: ["String", "Array[String]", "Hash[String, String]"]
      #
      # @param types_str [String]
      # @return [Array<String>]
      def convert(types_str)
        types = []

        nested_level = 0
        current_type = []
        types_str.each_char.with_index(1) do |char, index|
          case char
          when ','
            if nested_level > 0
              current_type << char
            else
              types << current_type.join
              current_type = []
            end
          when '<'
            nested_level += 1
            current_type << "["
          when '>'
            nested_level -= 1
            current_type << "]"
          when ' '
            if current_type.any?
              current_type << " "
            end
          else
            current_type << char
          end

          if index == types_str.size
            types << current_type.join
          end
        end

        types
      end
    end
  end
end
