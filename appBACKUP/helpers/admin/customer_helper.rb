module Admin::CustomerHelper

  def customer_index_label(customer)
    if customer.first_name.blank? or customer.last_name.blank?
      customer.email
    elsif !customer.email.blank?
      raw(content_tag(:strong, "#{customer.last_name}, #{customer.first_name} ") + content_tag(:span, "(#{customer.email})", :class => 'preview'))
    else
      "#{customer.last_name}, #{customer.first_name}"
    end
  end

end