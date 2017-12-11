class Transaccion < ApplicationRecord


def calcular_porcentaje_actual(precio_base, precio_actual, tipo_transaccion)
	porcentaje =  ((precio_actual / precio_base) - 1 ) * 100
	if tipo_transaccion == "compra"
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

def logica_principal(valor_inicial, moneda, porcentaje)
	valor_inicial = valor_inicial
	valor_final = 0
	cantidad_monedas = 0
	comprar_moneda = true
	precio_actual = Exchange.new
	precio_actual = precio_actual.tickers('tBCHUSD')[0]
	puts("El precio actual es: #{precio_actual}")
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
