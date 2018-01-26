describe Mifiel::User do
  describe '#create' do
    let(:user) do
      Mifiel::User.create(
        email: 'user@email.com',
        tax_id: 'AAA010101AAA',
        callback_url: 'http://some-callback.url/mifiel'
      )
    end

    it { expect(user.success).to be_truthy }
    it { expect(user.widget_id).to_not be_nil }
  end
end
