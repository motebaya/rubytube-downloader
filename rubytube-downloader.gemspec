# ruby package setup
# rubytube-dl.gemspec
require "rake"

Gem::Specification.new do |s|
  s.name        = 'rubytube-downloader'
  s.version     = '1.2.0'
  s.authors     = ['Motebaya']
  s.email       = 'motebaya@github.com'
  s.summary     = 'ruby script to download video/shorts from youtube'
  s.description = 'ruby script to download video/short media from youtube'
  s.license     = 'MIT'

  s.files       = ['lib/*_class.rb', 'bin/rubytube-dl']
  s.require_path = 'lib'

  s.add_dependency 'httparty', '~> 0.21.0'

  s.executables  = ['rubytube-dl']
  s.bindir       = 'bin'
end
