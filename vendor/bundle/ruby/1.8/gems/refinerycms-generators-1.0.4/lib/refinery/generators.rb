require 'refinerycms-base'
require 'pathname'

module Refinery
  module Generators
    autoload :EngineInstaller, File.expand_path('../generators/engine_installer', __FILE__)
    autoload :Migrations, File.expand_path('../generators/migrations', __FILE__)
  end
end