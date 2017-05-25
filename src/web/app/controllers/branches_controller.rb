class BranchesController < ApplicationController
  def index
    send_get('http://rest_app:3001/branches')
  end

  def show
    send_get("http://rest_app:3001/branches/#{params[:id]}")
  end
end
