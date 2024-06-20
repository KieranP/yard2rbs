# frozen_string_literal: true

require "prism"

# https://ruby.github.io/prism/rb/index.html
# https://github.com/ruby/rbs/blob/master/docs/syntax.md
# https://github.com/ruby/rbs/blob/master/lib/rbs/prototype/rb.rb

module Yard2rbs
  class Converter
    # @param input_path [String]
    # @return [void]
    def initialize(input_path)
      @parse_result = Prism.parse_file(input_path)
      @parse_result.attach_comments!
      @output = []
    end

    # @return [String]
    def convert
      @_indent_level = 0
      # puts @parse_result.value.inspect
      process(@parse_result.value)
      output = @output.join("\n")
      validate(output)
      output
    end

    private

    # @param node [Prism::Node]
    # @return [true]
    def process(node)
      case node
      when Array
        node.each do |v|
          process(v)
        end

      when Prism::ClassNode
        if node.superclass
          output("class #{node.constant_path.name} < #{node.superclass.name}")
        else
          output("class #{node.constant_path.name}")
        end
        @_indent_level += 1
        process(node.compact_child_nodes)
        @_indent_level -= 1
        output("end")

      when Prism::SingletonClassNode
        @_within_singleton = true
        process(node.compact_child_nodes)
        @_within_singleton = false

      when Prism::ModuleNode
        output("module #{node.constant_path.name}")
        @_indent_level += 1
        process(node.compact_child_nodes)
        @_indent_level -= 1
        output("end")

      when Prism::ConstantWriteNode
        types = parse_comments(node)
        type = format_types(types[:returns])
        output("#{node.name}: #{type}")

      when Prism::ClassVariableWriteNode
        output("#{node.name}: untyped")

      when Prism::InstanceVariableWriteNode
        output("self.#{node.name}: untyped")

      when Prism::DefNode
        visibility = @_visibility_node&.name
        receiver = "self." if self?(node)

        types = parse_comments(@_visibility_node || node)
        params = []
        block = nil

        if node.parameters
          if node.parameters.requireds
            node.parameters.requireds.each do |arg|
              type = format_types(types[:params][arg.name.to_s])
              params << "#{type} #{arg.name}"
            end
          end

          if node.parameters.optionals
            node.parameters.optionals.each do |arg|
              type = format_types(types[:params][arg.name.to_s])
              params << "?#{type} #{arg.name}"
            end
          end

          if arg = node.parameters.rest
            type = format_types(types[:params][arg.name.to_s])
            params << "*#{type} #{arg.name}"
          end

          if node.parameters.keywords
            node.parameters.keywords.each do |arg|
              type = format_types(types[:params][arg.name.to_s])
              if arg.is_a?(Prism::OptionalKeywordParameterNode)
                params << "?#{arg.name}: #{type}"
              else
                params << "#{arg.name}: #{type}"
              end
            end
          end

          if arg = node.parameters.keyword_rest
            type = format_types(types[:params][arg.name.to_s])
            params << "**#{type} #{arg.name}"
          end

          if arg = node.parameters.block
            block = "{ (?) -> untyped }"
          end
        end

        return_type = format_types(types[:returns])

        output([
          visibility,
          "def",
          "#{receiver}#{node.name}:",
          "(#{params.join(", ")})",
          block,
          "-> #{return_type}"
        ].compact.join(' '))

      when Prism::CallNode
        case node.name
        when :public, :private
          if node.arguments
            @_visibility_node = node
            node.arguments.arguments.each do |inner_node|
              process(inner_node)
            end
            @_visibility_node = nil
          else
            receiver = "self." if self?(node)
            output("#{receiver}#{node.name}")
          end

        when :attr_accessor, :attr_reader, :attr_writer
          if node.arguments
            receiver = "self." if self?(node)
            node.arguments.arguments.each do |arg|
              output([
                "#{receiver}#{node.name}",
                "#{arg.unescaped}: untyped"
              ].compact.join(' '))
            end
          end

        when :extend, :prepend, :include
          if node.arguments
            receiver = "self." if self?(node)
            node.arguments.arguments.each do |arg|
              output("#{receiver}#{node.name} #{arg.name}")
            end
          end

        when :alias_method
          if node.arguments
            args = node.arguments.arguments
            new_name = args.first.unescaped
            old_name = args.last.unescaped
            output("#{receiver}alias #{new_name} #{old_name}")
          end

        else
          process(node.compact_child_nodes)
        end

      when Prism::AliasMethodNode
        new_name = node.new_name.unescaped
        old_name = node.old_name.unescaped
        output("alias #{new_name} #{old_name}")

      else
        process(node.compact_child_nodes)
      end

      true
    end

    # @param output [String]
    # @return [true]
    def validate(output)
      RBS::Parser.parse_signature(output)
      true
    end

    # @param str [String]
    # @return [String]
    def output(str)
      @output << ("  " * @_indent_level) + str
    end

    # @param node [Prism::Node]
    # @return [Boolean]
    def self?(node)
      node.receiver&.type == :self_node ||
        @_within_singleton
    end

    # @param node [Prism::Node]
    # @return [Hash]
    def parse_comments(node)
      params = {}
      returns = []

      comments = node.location.comments
      comments&.each do |comment|
        line = comment.slice

        case line
        when /@param/
          if matches = line.match(/# @param ([^\s]+) \[([^\]]+)\].*/)
            types = matches[2].split(',').map(&:strip)
            params[matches[1]] = convert_types(types)
          end
        when /@return/
          if matches = line.match(/# @return \[([^\]]+)\].*/)
            types = matches[1].split(',').map(&:strip)
            returns += convert_types(types)
          end
        end
      end

      {
        params: params,
        returns: returns,
      }
    end

    # @param types [String]
    # @return [Array<String>]
    def convert_types(types)
      types.map do |type|
        type.
          gsub(/Array\<([^>]+)\>/, 'Array[\1]').
          gsub(/Hash\<([^>]+),\s*([^>]+)\>/, 'Hash[\1,\2]')
      end
    end

    # @param types [Array<String>]
    # @return [String]
    def format_types(types)
      return 'untyped' if !types || types.size == 0

      nilable = true if types.delete('nil')

      if types.size > 1
        "(#{types.join(' | ')})#{'?' if nilable}"
      else
        "#{types.first}#{'?' if nilable}"
      end
    end
  end
end
