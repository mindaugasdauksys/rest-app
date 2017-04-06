class BranchesController < ApplicationController
  def index
    render json: Branch.all
  end

  def show
    render json: Branch.find(params[:id])
  end
end
