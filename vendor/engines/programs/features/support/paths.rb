module NavigationHelpers
  module Refinery
    module Programs
      def path_to(page_name)
        case page_name
        when /the list of programs/
          admin_programs_path

         when /the new program form/
          new_admin_program_path
        else
          nil
        end
      end
    end
  end
end
