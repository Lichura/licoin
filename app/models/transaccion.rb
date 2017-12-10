class Transaccion < ApplicationRecord


class Exchange
  include HTTParty
  base_uri 'https://api.bitfinex.com'



  def tickers(moneda)
    self.class.get("/v2/ticker/#{moneda}")
  end

  def trades(moneda)
    self.class.get("/v2/trades/#{moneda}")
  end
end


end
