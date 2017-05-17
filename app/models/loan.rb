class Loan < ActiveRecord::Base
  has_many :payments, dependent: :destroy

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

  def payment_exceeds_balance?(payment_amount)
    payment_amount > self.outstanding_balance
  end
end
