class LoansController < ApplicationController
  def index
    render json: Loan.all.map(&:default_json)
  end

  def show
    render json: Loan.includes(:payments).find(params[:id]).default_json
  end
end
