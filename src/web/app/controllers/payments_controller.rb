require 'net/http'

# payments controller
class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def carry
    result = RequestPatchUrl.call('http://rest_app:3001/payments/carry',
                                  params.slice(:payment))
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end
end
