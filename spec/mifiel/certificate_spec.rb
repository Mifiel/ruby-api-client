describe Mifiel::Certificate do
  describe '#create' do
    let(:certificate) do
      Mifiel::Certificate.create(
        'spec/fixtures/FIEL_AAA010101AAA.cer'
      )
    end

    it { expect(certificate).to be_a(Mifiel::Certificate) }
  end

end
