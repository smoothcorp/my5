Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-programs'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Programs engine for Refinery CMS'
  s.date              = '2012-05-11'
  s.summary           = 'Programs engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir['lib/**/*', 'config/**/*', 'app/**/*']
end
