class IndexController < ApplicationController
  def index
  	@exchange = Transaccion::Exchange.new
  	@tickers = @exchange.tickers('tBCHUSD')
  	@estado = "sin iniciar"
  	if Transaccion.last.present?
		@precio_anterior = Transaccion.last.precio_actual
  		@variacion = (((@tickers[0].to_f / @precio_anterior) - 1) * 100).to_s + "%"
  	else
  		@precio_anterior = 0
  		@variacion = 0.00
  	end
  end

  def get_actual_price
  	@exchange = Transaccion::Exchange.new
	@tickers = @exchange.tickers('tBCHUSD')
	puts(@tickers)
	@precio_anterior = Transaccion.last.precio_actual
	@variacion = (((@tickers[0].to_f / @precio_anterior) - 1) * 100).to_s + "%"
	respond_to do |format|
    	format.js
  	end
  end

  def iniciar_bot
    @transaccion = Transaccion.new
    #al ser la primera vez que se inicia tengo que comprar si o si
	run_inicial = true
	iteraciones = params[:iteraciones].to_i
    for i in (0..iteraciones) do
	    @plata, @monedas = @transaccion.ejecutar_bot(params[:moneda][:id],params[:plata].to_f,params[:porcentaje].to_f, run_inicial)
	    run_inicial = false
	   	@iteracion = i
	   	@estado = "ejecutando"
	   	sleep 30
	end
	@estado = "finalizado"
	respond_to do |format|
	    format.js
	 end
  end

  def guardar_precio_historico(precio)
  	@transaccion = Transaccion.new(precio_actual: precio)
  	@transaccion.save
  end


  private

 	def bot_params
  		params.require(:bot).permit(:moneda, :plata, :porcentaje)
	end
end
