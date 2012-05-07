class ActiveMerchantHelper
  def self.credit_card_from_details(details)
    if details.blank?
      first_name = last_name = ""
    else
      names = details[:name_on_card].split
      last_name  = names.pop
      first_name = names.join(" ")
    end

    ActiveMerchant::Billing::CreditCard.new(
      :number               => details[:card_number],
      :month                => details[:expiry_month],
      :year                 => details[:expiry_year],
      :first_name           => first_name,
      :last_name            => last_name,
      :verification_value   => details[:verification]
    )
  end
end