class Payment < ActiveRecord::Base

  attr_accessor :eway_token

  # Validations

  validates :amount, :presence => true

  # Class Methods

  def self.config
    @@config ||= begin
      path = [Rails.root, 'config', 'my5.yml'].join('/')
      YAML::load(File.open path).symbolize_keys
    end
  end

  # Instance Methods

  def amount_in_cents
    return 0 if self.amount.nil?
    (self.amount * 100).to_i
  end

  def paid?
    self.status == 1
  end

  def can_process?
    (self.eway_token && self.amount) && self.status == 0
  end

  def process
    invoice_no = "MY5#{Payment.count}"

    config = Payment.config[:eway][Rails.env].symbolize_keys
    gateway = ActiveMerchant::Billing::EwayManagedGateway.new(config)
    options = { :invoice => invoice_no, :description  => 'Yearly Subscription' }
    response = gateway.purchase self.amount_in_cents, self.eway_token, options

    if response.success?
      response.authorization

      self.status = 1
      self.invoice_no = invoice_no
      self.save
    end
    puts response.message

    response.success?
  end
end