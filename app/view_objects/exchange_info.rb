require 'currency'

# view object for exchange info
class ExchangeInfo
  include ActionView::Helpers
  ACCEPTED_CURRENCIES = %w[EUR USD].freeze
  attr_reader :currency, :amount

  def initialize(money)
    @currency = money.currency
    @amount = money.amount
  end

  def html
    content_tag :div, exchange_info.join('').html_safe, class: 'tabs'
  end

  private

  def exchange_info
    available_currencies.map { |to| format_exchange_info(to) }
  end

  def format_exchange_info(to)
    simple_format(trade_line(to)) + simple_format(trade_result_line(to))
  end

  def available_currencies
    ACCEPTED_CURRENCIES - [currency]
  end

  def trade_result_line(to)
    'After conversion you would have '\
    "#{Currency.ratio(currency, to) * amount} #{to}"
  end

  def trade_line(to)
    "Convert from #{currency} to #{to} with "\
    "ratio #{Currency.ratio(currency, to)}"
  end
end
