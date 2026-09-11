# frozen_string_literal: true

module Mifiel
  # Account-level webhook subscriptions.
  # @see https://docs.mifiel.com/en/#tag/Webhooks
  class Webhook < Mifiel::Base
    get :all, '/webhooks'
    get :find, '/webhooks/:id'
    post :create, '/webhooks'
    delete :delete, '/webhooks/:id'

    # Trigger delivery for this webhook.
    #
    # @param resource [String] UUID of the related resource included in the callback payload
    # @param instant [Boolean] when true, deliver immediately once instead of enqueueing retries
    def trigger(resource:, instant: false)
      self.class.process_request(
        "/webhooks/#{id}/trigger",
        :post,
        payload: { resource: resource, instant: instant },
      )
    end
  end
end
