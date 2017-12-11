class Transaccion < ApplicationRecord


def calcular_porcentaje_actual(precio_base, precio_actual, tipo_transaccion)
	porcentaje =  ((precio_actual / precio_base) - 1 ) * 100
	if tipo_transaccion 
		porcentaje = porcentaje * (-1)
	end
	return porcentaje
end

def evaluar_porcentaje(porcentaje, porcentaje_esperado)
	if porcentaje_esperado > porcentaje
		puts ("se debe realizar la transaccion")
		return true
	end
end

def ejecutar_orden(moneda, precio_actual, plata, compra)
	if compra
		moneda = plata / precio_actual
		plata = 0
	else
		plata = moneda * precio_actual
		moneda = 0
	end
	return plata, moneda
end

def logica_principal(valor_inicial, moneda, porcentaje, comprar_moneda)
	run_inicial = true
	valor_inicial = valor_inicial
	valor_final = valor_inicial
	cantidad_monedas = 0
	porcentaje = porcentaje
	precio_actual = Exchange.new
	precio_actual = precio_actual.tickers('tBCHUSD')[0]


	puts("El precio actual es: #{precio_actual}")
	porcentaje_actual = calcular_porcentaje_actual(valor_final, precio_actual, comprar_moneda)
	

	puts("El porcentaje actual es: #{porcentaje_actual}")
	realizar_transaccion = evaluar_porcentaje(porcentaje_actual, porcentaje)

	if realizar_transaccion
		valor_final, cantidad_monedas = ejecutar_orden(cantidad_monedas, precio_actual, valor_final, comprar_moneda)
	end
	puts("valor_final: #{valor_final}, monedas: #{cantidad_monedas}")
	
	if comprar_moneda
		return cantidad_monedas
	else
		return valor_final
	end
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
