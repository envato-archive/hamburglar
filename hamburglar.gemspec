$:.unshift 'lib'

require 'hamburglar/version'

Gem::Specification.new do |s|
  s.name             = 'hamburglar'
  s.version          = Hamburglar::Version
  s.date             = Time.now.strftime('%Y-%m-%d')
  s.summary          = 'Hamburglar: Description here'
  s.homepage         = 'https://github.com/site5/hamburglar'
  s.authors          = ['Joshua Priddle']
  s.email            = 'jpriddle@site5.com'

  s.files            = %w[ Rakefile README.markdown ]
  s.files           += Dir['lib/**/*']
  s.files           += Dir['test/**/*']

  # s.add_dependency('gem', '= 0.0.0')

  s.add_development_dependency('rspec', '~> 2.6')

  s.extra_rdoc_files = ['README.markdown']
  s.rdoc_options     = ["--charset=UTF-8"]

  s.description = <<-DESC
    Hamburglar: Description here
  DESC
end
