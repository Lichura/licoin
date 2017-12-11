class Transaccion < ApplicationRecord


def calcular_porcentaje_actual(precio_base, precio_actual, tipo_transaccion)
	puts("el precio actual es: #{precio_actual} y el precio base es: #{precio_base}")
	porcentaje =  ((precio_actual / precio_base) - 1 ) * 100
	if tipo_transaccion 
		porcentaje = porcentaje * (-1)
	end
	puts("el porcentaje calculado es: #{porcentaje}" )
	return porcentaje
end

def evaluar_porcentaje(porcentaje, porcentaje_esperado)
	puts("porcentajes:")
	puts(porcentaje)
	puts(porcentaje_esperado)
	if porcentaje_esperado < porcentaje
		puts ("se debe realizar la transaccion")
		return true
	else
		return false
	end
end

def ejecutar_orden(moneda, plata, compra, precio_actual)
	if compra
		moneda.cantidad = plata / precio_actual
		moneda.valor_de_compra = precio_actual
		moneda.valor_de_venta = 0.00
		plata = 0
		compra = false
	else
		plata = moneda.cantidad * precio_actual
		moneda.cantidad = 0
		moneda.valor_de_compra = 0.00
		moneda.valor_de_venta = precio_actual
		compra = true
	end
	moneda.save
	return plata, compra
end

def ejecutar_bot(moneda, plata_inicial, porcentaje, run_inicial)
	

	#elijo la moneda que voy a utilizar
	@moneda = Moneda.find(moneda)
	codigo_moneda = "t#{@moneda.nombre}"

	#defino la cantidad de plata a utilizar
	plata = plata_inicial

	#defino mi porcentaje a comparar
	porcentaje = porcentaje
	compra = true

		precio_actual = Exchange.new
		precio_actual = precio_actual.tickers(codigo_moneda)[0]
		
		if run_inicial
			puts("hay run inicial")
			plata, compra = ejecutar_orden(@moneda, plata, run_inicial, precio_actual)
			@transaccion = Transaccion.new
			@transaccion.precio_actual = precio_actual
			@transaccion.compra = compra
			@transaccion.tipo_moneda = @moneda
			@transaccion.save
		end

		if compra
			puts("estoy comprando")
			porcentaje_actual = calcular_porcentaje_actual(@moneda.valor_de_venta, precio_actual, compra)
			realizar_transaccion = evaluar_porcentaje(porcentaje_actual, porcentaje)
			puts(realizar_transaccion)
		else
			puts("estoy vendiendo")
			porcentaje_actual = calcular_porcentaje_actual(@moneda.valor_de_compra, precio_actual, compra)
			realizar_transaccion = evaluar_porcentaje(porcentaje_actual, porcentaje)
			puts(realizar_transaccion)
		end

		if realizar_transaccion
			puts("se genera una nueva transaccion")
			plata, compra = ejecutar_orden(@moneda, plata, compra, precio_actual)
			#genero una nueva transaccion
			@transaccion = Transaccion.new
			@transaccion.precio_actual = precio_actual
			@transaccion.compra = compra
			@transaccion.tipo_moneda = @moneda
			@transaccion.save
		end


	return plata, @moneda.cantidad
end


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
