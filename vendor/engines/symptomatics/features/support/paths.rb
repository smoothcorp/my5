module NavigationHelpers
  module Refinery
    module Symptomatics
      def path_to(page_name)
        case page_name
        when /the list of symptomatics/
          admin_symptomatics_path

         when /the new symptomatic form/
          new_admin_symptomatic_path
        else
          nil
        end
      end
    end
  end
end
