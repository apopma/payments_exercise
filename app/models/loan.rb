class Loan < ActiveRecord::Base
  has_many :payments

  def default_json
    {
      id: self.id,
      funded_amount: self.funded_amount,
      outstanding_balance: outstanding_balance,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  def outstanding_balance
    return self.funded_amount unless self.payments.present?
    self.funded_amount - self.payments.map(&:payment_amount).inject(:+)
  end
end
