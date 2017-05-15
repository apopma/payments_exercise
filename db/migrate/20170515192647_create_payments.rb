class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :loan_id, null: false
      t.decimal :payment_amount, null: false, precision: 8, scale: 2
      t.datetime :payment_date, null: false
      t.timestamps null: false

      t.index :loan_id
      t.index :payment_date
    end
  end
end
