class BranchesController < ApplicationController
  def index
    render json: Branch.all
  end

  def show
    render json: Branch.find_by_id(params[:id])
  end
end
