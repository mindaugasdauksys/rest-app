class AccountsController < ApplicationController
  require 'rest-client'
  skip_before_action :verify_authenticity_token
  before_filter :authenticate_request!, only:  [:show, :index]
  before_filter :authenticate_admin!, only: [:create, :update, :destroy]
  def index
    send_get('http://rest_app:3001/accounts')
  end

  def show
    send_get("http://rest_app:3001/accounts/#{params[:id]}")
  end

  def create
    address = "http://rest_app:3001/accounts"
    final_url = nil
    begin
    RestClient.post address, params.to_json, {content_type: :json, accept: :json} do |response, request, result, &block|
      if [301, 302, 307].include? response.code
        final_url = response.headers[:location]
      else
        final_url = request.url
        puts "redirected to: #{final_url}"
        response.return!(&block)
      end
    end
    rescue Exception => e
      head e.response.code
      return
    end
    send_get final_url
  end

  def update
    address = "http://rest_app:3001/accounts/#{params[:id]}"
    final_url = nil
    begin
    RestClient.patch address, account_params.to_json, {content_type: :json, accept: :json} do |response, request, result, &block|
      if [301, 302, 307].include? response.code
        final_url = response.headers[:location]
      else
        final_url = request.url
        puts "redirected to: #{final_url}"
        response.return!(&block)
      end
    end
    rescue Exception => e
      head e.response.code
      return
    end
    send_get final_url
  end

  def destroy
    address = "http://rest_app:3001/accounts/#{params[:id]}"
    final_url = nil
    begin
    RestClient.delete address, {content_type: :json, accept: :json} do |response, request, result, &block|
      if [301, 302, 307].include? response.code
        final_url = response.headers[:location]
      else
        final_url = request.url
        puts "redirected to: #{final_url}"
        response.return!(&block)
      end
    end
    rescue Exception => e
      puts "exception #{e}"
      head e.response.code
      return
    end
    send_get final_url
  end

  def convert
    address = "http://rest_app:3001/#{params[:id]}/convert"
    final_url = nil
    begin
    RestClient.patch address, params.to_json, {content_type: :json, accept: :json} do |response, request, result, &block|
      if [301, 302, 307].include? response.code
        final_url = response.headers[:location]
      else
        final_url = request.url
        puts "redirected to: #{final_url}"
        response.return!(&block)
      end
    end
    rescue Exception => e
      puts "exception #{e}"
      head e.response.code
      return
    end
    send_get final_url
  end

  private

  def account_params
    params.fetch(:account, {}).permit(:name, :surname, :amount, :currency)
  end
end
