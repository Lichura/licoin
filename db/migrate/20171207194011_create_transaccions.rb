class CreateTransaccions < ActiveRecord::Migration[5.0]
  def change
    create_table :transaccions do |t|
      t.float :precio_actual
      t.string :tipo_moneda
      t.float :precio_maximo
      t.float :precio_minimo
      t.float :porcentaje
      t.boolean :compra

      t.timestamps
    end
  end
end
