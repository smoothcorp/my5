module ApplicationHelper
    def vimeo_helper(url)
        url = "http://player.vimeo.com/video/#{url[/vimeo.com\/([^&]+)/, 1]}"

        content_tag(:div, :class => 'vimeo') do
          content_tag(:iframe, nil, :src => url, :frameborder => '0')
        end
      end
end
