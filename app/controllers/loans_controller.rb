class LoansController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    render json: Loan.all.map(&:default_json)
  end

  def show
    render json: Loan.includes(:payments).find(params[:id]).default_json
  end
end
