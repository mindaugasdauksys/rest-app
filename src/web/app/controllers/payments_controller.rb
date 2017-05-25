require 'net/http'

class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    send_get('http://rest_app:3001/payments')
  end

  def show
    send_get("http://rest_app:3001/payments/#{params[:id]}")
  end

  def payment_params
    params.fetch(:payment, {}).permit(:from, :to, :amount, :currency)
  end

  def create
    address = "http://rest_app:3001/payments"
    final_url = nil
    begin
    RestClient.post address, payment_params.to_json, {content_type: :json, accept: :json} do |response, request, result, &block|
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
    address = "http://rest_app:3001/payments/#{params[:id]}"
    final_url = nil
    begin
    RestClient.patch address, payment_params.to_json, {content_type: :json, accept: :json} do |response, request, result, &block|
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
    address = "http://rest_app:3001/payments/#{params[:id]}"
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

  def carry
    address = "http://rest_app:3001/payments/carry"
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
end
