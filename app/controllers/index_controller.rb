class IndexController < ApplicationController
  def index
  	@exchange = Transaccion::Exchange.new
  	@tickers = @exchange.tickers('tBCHUSD')
  	guardar_precio_historico(@tickers[0])
	@precio_anterior = Transaccion.last.precio_actual
  	@variacion = (((@tickers[0].to_f / @precio_anterior) - 1) * 100).to_s + "%"
  	puts @tickers
  end

  def get_actual_price
  	@exchange = Transaccion::Exchange.new
	@tickers = @exchange.tickers('tBCHUSD')
	@precio_anterior = Transaccion.last.precio_actual
	guardar_precio_historico(@tickers[0])
	@variacion = (((@tickers[0].to_f / @precio_anterior) - 1) * 100).to_s + "%"
	respond_to do |format|
    	format.js
  	end
  end

  def iniciar_bot
    @transaccion = Transaccion.new
    puts(params[:plata])
    puts(params[:porcentaje])
    @transaccion = @transaccion.logica_principal(params[:plata].to_f,'BCH',params[:porcentaje].to_f, true)
    respond_to do |format|
      format.js
    end
  end

  def guardar_precio_historico(precio)
  	@transaccion = Transaccion.new(precio_actual: precio)
  	@transaccion.save
  end
end
