class BranchesController < ApplicationController
  def index
    render json: Branch.all
  end

  def show
    @branch = Branch.find_by_id(params[:id])
    if @branch
      render json: @branch
    else
      render_404
    end
  end
end
