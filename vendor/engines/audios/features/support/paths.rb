module NavigationHelpers
  module Refinery
    module Audios
      def path_to(page_name)
        case page_name
        when /the list of audios/
          admin_audios_path

         when /the new audio form/
          new_admin_audio_path
        else
          nil
        end
      end
    end
  end
end
