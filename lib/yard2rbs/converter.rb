# frozen_string_literal: true

require 'prism'
require 'rbs'
require 'fileutils'

# https://ruby.github.io/prism/rb/index.html
# https://github.com/ruby/rbs/blob/master/docs/syntax.md
# https://github.com/ruby/rbs/blob/master/lib/rbs/prototype/rb.rb
# https://rubydoc.info/gems/yard/file/docs/GettingStarted.md

module Yard2rbs
  class Converter
    class << self
      # @param input_path [String]
      # @param validate [Boolean]
      # @return [String]
      def convert(input_path, validate: true)
        new(input_path).convert(validate:)
      end

      # @param input [String]
      # @return [true]
      def validate(input)
        RBS::Parser.parse_signature(input)
        true
      end
    end

    # @param input_path [String]
    # @return [void]
    def initialize(input_path)
      @parse_result = Prism.parse_file(input_path)
      @parse_result.attach_comments!
      @output = []
    end

    # @param validate [Boolean]
    # @return [String]
    def convert(validate: true)
      @_indent_level = 0
      @_superclasses = []
      # puts @parse_result.value.inspect
      process(@parse_result.value)
      output = @output.join("\n")
      Converter.validate(output) if validate
      output
    end

    private

    # @param node [Prism::Node, Array<Prism::Node>]
    # @return [true]
    def process(node)
      case node
      when Array
        node.each do |v|
          process(v)
        end

      when Prism::ClassNode
        if node.superclass
          case node.superclass
          when Prism::SelfNode
            output("class #{node.constant_path.name} < ::#{@_superclasses.join('::')}")
          else
            paths = parse_constant_path(node.superclass)
            output("class #{node.constant_path.name} < #{paths.join('::')}")
          end
        else
          output("class #{node.constant_path.name}")
        end

        @_indent_level += 1
        @_superclasses << node.constant_path.name
        process(node.compact_child_nodes)
        @_superclasses.pop
        @_indent_level -= 1
        output('end')

      when Prism::SingletonClassNode
        @_within_singleton = true
        process(node.compact_child_nodes)
        @_within_singleton = false

      when Prism::ModuleNode
        output("module #{node.constant_path.name}")
        @_indent_level += 1
        @_superclasses << node.constant_path.name
        process(node.compact_child_nodes)
        @_superclasses.pop
        @_indent_level -= 1
        output('end')

      when Prism::ConstantWriteNode
        types = parse_comments(node)
        type = format_types(types[:returns])
        output("#{node.name}: #{type}")

      when Prism::ClassVariableWriteNode
        types = parse_comments(node)
        type = format_types(types[:returns])
        output("#{node.name}: #{type}")

      when Prism::InstanceVariableWriteNode
        types = parse_comments(node)
        type = format_types(types[:returns])
        output("self.#{node.name}: #{type}")

      when Prism::DefNode
        visibility = @_visibility_node&.name
        visibility = 'private' if visibility == :private_class_method

        receiver = 'self.' if self?(node)

        types = parse_comments(@_visibility_node || node)
        params = []
        block = nil

        node.parameters&.requireds&.each do |arg|
          type = format_types(types[:params][arg.name.to_s])
          params << "#{type} #{arg.name}"
        end

        node.parameters&.optionals&.each do |arg|
          type = format_types(types[:params][arg.name.to_s])
          params << "?#{type} #{arg.name}"
        end

        if (rest_arg = node.parameters&.rest)
          type = format_types(types[:params][rest_arg.name.to_s])
          params << "*#{type}"
        end

        node.parameters&.keywords&.each do |arg|
          type = format_types(types[:params][arg.name.to_s])
          params <<
            if arg.is_a?(Prism::OptionalKeywordParameterNode)
              "?#{arg.name}: #{type}"
            else
              "#{arg.name}: #{type}"
            end
        end

        if (kw_rest_arg = node.parameters&.keyword_rest)
          case kw_rest_arg
          when Prism::ForwardingParameterNode
            params_type = format_types(types[:params]['...'])
            params << "*#{params_type}"
            params << "**#{params_type}"
            block = '?{ (?) -> untyped }'
          else
            type = format_types(types[:params][kw_rest_arg.name.to_s])
            params << "**#{type}"
          end
        end

        if node.parameters&.block
          yieldparams =
            types[:yieldparams].map do |name, yield_types|
              type = format_types(yield_types)
              "#{type} #{name}"
            end

          return_type = format_types(types[:yieldreturns])

          block = "{ (#{yieldparams.join(', ')}) -> #{return_type} }"
        end

        return_type = format_types(types[:returns])

        output([
          visibility,
          'def',
          "#{receiver}#{node.name}:",
          "(#{params.join(', ')})",
          block,
          "-> #{return_type}"
        ].compact.join(' '))

      when Prism::CallNode
        case node.name
        when :public, :private, :private_class_method
          if node.arguments
            @_visibility_node = node
            node.arguments.arguments.each do |inner_node|
              process(inner_node)
            end
            @_visibility_node = nil
          else
            output(node.name.to_s)
          end

        when :attr_accessor, :attr_reader, :attr_writer
          if node.arguments
            receiver = 'self.' if self?(node)
            types = parse_comments(node)
            type = format_types(types[:returns])
            node.arguments.arguments.each do |arg|
              output([
                "#{receiver}#{node.name}",
                "#{arg.unescaped}: #{type}"
              ].compact.join(' '))
            end
          end

        when :extend, :prepend, :include
          if node.arguments
            receiver = 'self.' if self?(node)
            node.arguments.arguments.each do |arg|
              paths = parse_constant_path(arg)
              next if paths.none?

              output("#{receiver}#{node.name} #{paths.join('::')}")
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

    # @param str [String]
    # @return [String]
    def output(str)
      @output << (('  ' * @_indent_level) + str)
    end

    # @param node [Prism::Node]
    # @return [Boolean]
    def self?(node)
      node.receiver&.type == :self_node ||
        @_within_singleton
    end

    # @param node [Prism::Node]
    # @return [Hash{Symbol => Array<String>, Hash<String, String>}]
    def parse_comments(node)
      comments = node.location.comments.map(&:slice)
      YardParser.parse(comments)
    end

    # @param types [Array<String>, nil]
    # @return [String]
    def format_types(types)
      return 'untyped' if !types || types.empty?

      nilable = true if types.delete('nil')

      if types.size > 1
        "(#{types.join(' | ')})#{'?' if nilable}"
      else
        "#{types.first}#{'?' if nilable}"
      end
    end

    # @param node [Prism::Node]
    # @param paths [Array<Symbol>]
    # @return [Array<Symbol>]
    def parse_constant_path(node, paths = [])
      return paths unless node

      case node
      when Prism::ConstantPathNode
        parse_constant_path(node.parent, paths)
        paths << node.name
      when Prism::ConstantReadNode
        paths << node.name
      end

      paths
    end
  end
end
