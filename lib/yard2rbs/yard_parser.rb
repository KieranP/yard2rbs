# frozen_string_literal: true

# TODO: Make some classes top level via :: (e.g. String -> ::String)

module Yard2rbs
  class YardParser
    class << self
      # @param comments [Array<String>]
      # @return [Hash{Symbol => Array<String>, Hash<String, String>}]
      def parse(comments)
        params = {}
        returns = []

        yieldparams = {}
        yieldreturns = []

        comments&.each do |comment|
          case comment
          when /@param/
            matches = comment.match(/# @param ([^\s]+) \[([^\]]+)\].*/)
            params[matches[1]] = convert(matches[2]) if matches

          when /@return/
            matches = comment.match(/# @return \[([^\]]+)\].*/)
            returns += convert(matches[1]) if matches

          when /@yieldparam/
            matches = comment.match(/# @yieldparam ([^\s]+) \[([^\]]+)\].*/)
            yieldparams[matches[1]] = convert(matches[2]) if matches

          when /@yieldreturn/
            matches = comment.match(/# @yieldreturn \[([^\]]+)\].*/)
            yieldreturns += convert(matches[1]) if matches
          end
        end

        {
          params:,
          returns:,

          yieldparams:,
          yieldreturns:
        }
      end

      # Converts YARD type string into RBS type array
      # e.g. Input:  'String, Array<String>, Hash<String, String>'
      #      Output: ['String', 'Array[String]', 'Hash[String, String]']
      #
      # @param types_str [String]
      # @return [Array<String>]
      def convert(types_str)
        types = []
        context_stack = []
        current_type_chars = []
        current_word_chars = []

        types_str = types_str.tr(' ', '')
        types_str.each_char.with_index(1) do |char, index|
          case char
          when ','
            current_type_chars += mutate(current_word_chars)
            current_word_chars = []

            case context_stack.last
            when 'Hash', 'Tuple'
              current_type_chars << ', '
            when 'Array', 'HashComplex'
              current_type_chars << ' | '
            when nil
              types << current_type_chars.join
              current_type_chars = []
            end

          when '<'
            context_stack << current_word_chars.join
            current_type_chars += mutate(current_word_chars)
            current_word_chars = []
            current_type_chars << '['

          when '>'
            if context_stack.last == 'HashComplex'
              current_word_chars.pop
              current_type_chars += mutate(current_word_chars)
              current_word_chars = []
              current_type_chars << ', '
            else
              context_stack.pop
              current_type_chars += mutate(current_word_chars)
              current_word_chars = []
              current_type_chars << ']'
            end

          when '('
            context_stack << 'Tuple'
            current_word_chars = []
            current_type_chars << '['

          when ')'
            context_stack.pop
            current_type_chars += mutate(current_word_chars)
            current_word_chars = []
            current_type_chars << ']'

          when '{'
            context_stack << 'HashComplex'
            current_type_chars += mutate(current_word_chars)
            current_word_chars = []
            current_type_chars << '['

          when '}'
            context_stack.pop
            current_type_chars += mutate(current_word_chars)
            current_word_chars = []
            current_type_chars << ']'

          else
            current_word_chars << char
          end

          if index == types_str.size
            current_type_chars += mutate(current_word_chars)
            types << current_type_chars.join
            current_type_chars = []
          end
        end

        types
      end

      # @param type [Array<String>]
      # @return [Array<String>]
      def mutate(chars)
        case chars.join
        when 'Boolean'
          'bool'.split
        else
          chars
        end
      end
    end
  end
end
