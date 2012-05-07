module NavigationHelpers
  module Refinery
    module AudioPrograms
      def path_to(page_name)
        case page_name
        when /the list of audio_programs/
          admin_audio_programs_path

         when /the new audio_program form/
          new_admin_audio_program_path
        else
          nil
        end
      end
    end
  end
end
