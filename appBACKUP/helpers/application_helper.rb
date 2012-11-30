module ApplicationHelper

   def page_url(page_type=nil,page_id=nil)
    @url = "unknown"
    @counts = 0
    if page_id.nil? && page_id.blank?
      @url = "#{request.env['HTTP_HOST']}/#{page_type}"
      @counts = @custmer_visit.select{ |report| report if report.controller_name == "#{page_type}"  }
    else
      
      if page_id == 0
      @url = "#{request.env['HTTP_HOST']}/#{page_type}"
      @counts = @custmer_visit.select{ |report| report if report.controller_name == "#{page_type}" && report.show_id.to_i == 0 }
      else
      if page_type == "my5/mini_modules"
        @url = "#{request.env['HTTP_HOST']}/#{page_type}/#{page_id}/1000"
      else
        @url = "#{request.env['HTTP_HOST']}/#{page_type}/#{page_id}"
      end
      @counts = @custmer_visit.select{ |report| report if report.controller_name == "#{page_type}" && report.show_id == page_id }
      end
    end
     @side_data.push(@counts.size)
    return  @url,@counts.size   
   end
   
   def  count_percentage(data_view,data_array)
       if !data_array.nil? && !data_array.blank?
       @percentage_data = "["
       @page_1 = "["
       @page_2 = "["
       @page_total =  data_array.sum
       if @page_total > 0
           data_array.each_with_index do |data,index|
               if index != 0
               @page_1 += ","
               @page_2 += ","
               end 
               per = (data.to_f/@page_total.to_f)*100
               @percentage_data += "['#{data_view[index]}',#{per.round(2)} ]"
               @page_1 += "'#{data_view[index]}'"
               @page_2 += "#{per.round(0)}"
               @percentage_data += "," if ((index+1) != data_array.size)
           end
       end
       @page_1 += "]"
       @page_2 += "]"
       @percentage_data += "]"
    end
     
   end
   
   def payment_check(amount)
      return !amount.nil? && !amount.blank? ? number_with_precision(amount, :precision => 2) : number_with_precision(0,:precision => 2) 
   end
   
   
   
   
 

end
