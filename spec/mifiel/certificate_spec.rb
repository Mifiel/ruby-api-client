# frozen_string_literal: true

describe Mifiel::Certificate do
  describe '#create' do
    let(:certificate) do
      described_class.create(
        'spec/fixtures/FIEL_AAA010101AAA.cer',
      )
    end

    it { expect(certificate).to be_a(described_class) }
  end
end
