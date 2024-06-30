# frozen_string_literal: true

RSpec.describe Yard2rbs::YardParser do
  context '#convert' do
    [
      #
      # Basic Types
      #
      [
        'nil',
        ['nil']
      ],
      [
        'String',
        ['String']
      ],
      [
        'Integer',
        ['Integer']
      ],
      [
        'Boolean',
        ['bool']
      ],

      #
      # Array<>
      #
      [
        'Array<String>',
        ['Array[String]']
      ],
      [
        'Array<Boolean>',
        ['Array[bool]']
      ],
      [
        'Array<String, Boolean>',
        ['Array[String | bool]']
      ],
      [
        'Array<Hash<String, String>>',
        ['Array[Hash[String, String]]']
      ],
      [
        'Array<Hash<String, Boolean>>',
        ['Array[Hash[String, bool]]']
      ],
      [
        'Array<String, Hash<String, String>>',
        ['Array[String | Hash[String, String]]']
      ],

      #
      # Array()
      #
      [
        'Array(String)',
        ['[String]']
      ],
      [
        'Array(String, Integer, String)',
        ['[String, Integer, String]']
      ],
      [
        'Array(Array(Integer, Integer))',
        ['[[Integer, Integer]]']
      ],

      #
      # Hash<>
      #
      [
        'Hash<String, String>',
        ['Hash[String, String]']
      ],
      [
        'Hash<String, Boolean>',
        ['Hash[String, bool]']
      ],
      [
        'Hash<String, Array<String>>',
        ['Hash[String, Array[String]]']
      ],
      [
        'Hash<String, Array<Boolean>>',
        ['Hash[String, Array[bool]]']
      ],

      #
      # Hash{}
      #
      [
        'Hash{String => String}',
        ['Hash[String, String]']
      ],
      [
        'Hash{String => Boolean}',
        ['Hash[String, bool]']
      ],
      [
        'Hash{String => Array<String>}',
        ['Hash[String, Array[String]]']
      ],
      [
        'Hash{String => Array<Boolean>}',
        ['Hash[String, Array[bool]]']
      ],
      [
        'Hash{String => Array<Boolean>}',
        ['Hash[String, Array[bool]]']
      ],
      [
        'Hash{String => String, Integer}',
        ['Hash[String, String | Integer]']
      ],
      [
        'Hash{String, Integer => String}',
        ['Hash[String | Integer, String]']
      ],
      [
        'Hash{String, Integer => String, Integer}',
        ['Hash[String | Integer, String | Integer]']
      ],

      #
      # Multiple Types
      #
      [
        'String, Integer',
        ['String', 'Integer'] # rubocop:disable Style/WordArray
      ],
      [
        'String, Array<Integer>',
        ['String', 'Array[Integer]']
      ],
      [
        'Array<Integer>, String',
        ['Array[Integer]', 'String']
      ],
      [
        'Array<Integer>, Array<Integer>',
        ['Array[Integer]', 'Array[Integer]']
      ]

      #
      # Complex Types
      #
      # TODO
    ].each do |yard, rbs|
      it yard do
        output = described_class.convert(yard)
        expect(output).to eq rbs
      end
    end
  end
end
