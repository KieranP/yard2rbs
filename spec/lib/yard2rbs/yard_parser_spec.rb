# frozen_string_literal: true

RSpec.describe Yard2rbs::YardParser do
  context "#convert" do
    let(:input) do
      [
        "nil",
        "String",
        "Integer",
        "Array<String>",
        "Hash<String,String>",
        "Hash<String, String>",
        "Array<Hash<String,String>>",
        "Array<Hash<String, String>>",
        "Hash<String,Array<String>>",
        "Hash<String, Array<String>>",
      ].join(", ")
    end

    let(:output) do
      [
        "nil",
        "String",
        "Integer",
        "Array[String]",
        "Hash[String,String]",
        "Hash[String, String]",
        "Array[Hash[String,String]]",
        "Array[Hash[String, String]]",
        "Hash[String,Array[String]]",
        "Hash[String, Array[String]]",
      ]
    end

    it "correctly converts YARD types" do
      expect(described_class.convert(input)).to eq output
    end
  end
end
