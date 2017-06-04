# branches controller
class BranchesController < ApplicationController
  def index
    respond_with(@branches = Branch.all)
  end

  def show
    @branch = Branch.find_by_id(params[:id])
    if @branch
      respond_with @branch
    else
      render_code 404
    end
  end
end
