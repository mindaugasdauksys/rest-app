# accounts controller
class AccountsController < ApplicationController
  require 'rest-client'
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: %i[show index]
  before_action :authenticate_admin!, only: %i[create update destroy]

  def convert
    result = RequestPatchUrl.call("http://rest_app:3001/#{params[:id]}/convert",
                                  params.slice(:account))
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end
end
