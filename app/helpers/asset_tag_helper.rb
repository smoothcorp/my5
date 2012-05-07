module AssetTagHelper
  include ActionView::Helpers::AssetTagHelper

  alias :super_stylesheet_tag :stylesheet_link_tag
  alias :super_javascript_tag :javascript_include_tag

  def stylesheet_link_tag(*sources)
    if !sources.nil? && sources.first == :head
      traverse_head_dirs(sources[1...sources.count], :css)
    else
      super_stylesheet_tag(*sources)
    end
  end

  def javascript_include_tag(*sources)
    if !sources.nil? && sources.first == :head
      traverse_head_dirs(sources[1...sources.count], :js)
    else
      super_javascript_tag(*sources)
    end
  end

  private

  def normalise_format(format)
    {'css' => :css, 'js' => :js}[format] || format
  end

  def asset_dir(format)
    {:css => 'stylesheets', :js => 'javascripts'}[format] || ''
  end

  #
  # A valid source must be in the format:
  # => [ 'controller', 'action' ]
  # => [:controller => 'controller', :action => 'action' ]
  #
  def parse_source(source)
    if source.count == 1 && source.first.kind_of?(Hash) && source.first.key?(:controller)
      source = source.first
      controller = source[:controller]
      action = source.key?(:action) ? source[:action] : nil
    else
      controller = source.first
      action = source.count > 1 ? source[1] : nil
    end
    [controller, action]
  end

  def produce_paths(source, format)
    dirs = []
    controller = parse_source(source).first
    controller.split('/').each do |i|
      temp = (dirs.last.nil?) ? [] : dirs.last.clone
      dirs << (temp << i)
    end
    dirs.collect { |i| ['public', asset_dir(format), i].flatten.join('/') }
  end

  def add_asset(relative_path, format)
    return unless File.exist? "#{Rails.root}/#{relative_path}.#{format}"
    asset_path = relative_path.match(/^public\/(stylesheets|javascripts)\/(.*)$/)[2]

    if format == :css
      super_stylesheet_tag(asset_path, :media => 'screen, projection')
    elsif format == :js
      super_javascript_tag(asset_path)
    end
  end

  def traverse_head_dirs(source, format)
    return '' if source.nil? or source.empty?
    tags = []

    controller, action = parse_source(source)
    paths = produce_paths(source, format)
    paths.each do |path|
      tags << add_asset("#{path}/base", format)
      tags << add_asset("#{path}/#{action}", format) if action and path == paths.last
    end
    tags.join(%(\n)).html_safe
  end

end