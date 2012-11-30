class Refinery::CustomersController < ApplicationController

	before_filter :authenticate_user!
	layout 'admin'

	def bulk_import

		if request.post? && params[:file].present?
			infile = params[:file].read
			n, errs = 0, []
			header_row = ""
    		FasterCSV.parse(infile) do |row|
				n += 1
				if n == 1
					header_row = row
				end
				next if n == 1 or row.join.blank?
				customer = Customer.build_from_csv(row)
				if !customer.save
					p customer.errors.inspect
					p ">>>>"
					errs << row
			    else
		           SubscriptionsMailer.joined_welcome(customer,row[11]).deliver
				end
			end

			if errs.any?
				errFile ="errors_#{Date.today.strftime('%d%b%y')}.csv"
				errs.insert(0, header_row)
				errCSV = FasterCSV.generate do |csv|
					errs.each {|row| csv << row}
				end
				send_data errCSV,
					:type => 'text/csv; charset=iso-8859-1; header=present',
					:disposition => "attachment; filename=#{errFile}.csv"
			else
#				flash[:notice] = I18n.t('customer.import.success')
               	flash[:notice] = "Customer are Imported successfully."
				redirect_to bulk_import_customers_path
			end
		end
	end
end
