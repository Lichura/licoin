class CreateMonedas < ActiveRecord::Migration[5.0]
  def change
    create_table :monedas do |t|
      t.string :nombre
      t.decimal :valor_de_compra
      t.decimal :cantidad
      t.decimal :porcentaje_venta
      t.decimal :valor_de_venta

      t.timestamps
    end
  end
end
