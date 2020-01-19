# frozen_string_literal: true

describe Mifiel::User do
  describe '#setup_widget' do
    let(:user) do
      Mifiel::User.setup_widget(
        email: 'user@email.com',
        tax_id: 'AAA010101AAA',
        callback_url: 'http://some-callback.url/mifiel'
      )
    end

    it { expect(user.success).to be_truthy }
    it { expect(user.widget_id).to_not be_nil }
  end
end
