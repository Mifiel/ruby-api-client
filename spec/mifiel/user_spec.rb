# frozen_string_literal: true

describe Mifiel::User do
  describe '#setup_widget' do
    let(:user) do
      described_class.setup_widget(
        email: 'user@email.com',
        tax_id: 'AAA010101AAA',
        callback_url: 'http://some-callback.url/mifiel',
      )
    end

    it { expect(user.success).to be_truthy }
    it { expect(user.widget_id).not_to be_nil }
  end
end
