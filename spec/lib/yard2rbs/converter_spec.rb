# frozen_string_literal: true

RSpec.describe Yard2rbs::Converter do
  context "Samples" do
    Dir[__dir__ + "/../../samples/*.rb"].each do |input_path|
      input_dirname = File.dirname(input_path)
      input_filename = File.basename(input_path, ".*")
      it input_filename do
        converted = described_class.new(input_path).convert
        expected = File.read("#{input_dirname}/#{input_filename}.rbs")
        expect(converted).to eq expected.strip
      end
    end
  end
end
