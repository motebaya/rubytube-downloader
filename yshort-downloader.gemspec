require "rake"

Gem::Specification.new do |s|
  s.name        = 'yshort-downloader'
  s.version     = '1.1.2'
  s.summary     = "youtube shorts downloader with ruby"
  s.description = "ruby script for download youtube shorts media!"
  s.authors     = ["valsztrax"]
  s.email       = 'nyrtodaniel78@gmail.com'
  s.files       = FileList["lib/*"]
  s.executables << "yshort-dl"
  s.homepage    =
    'https://rubygems.org/gems/yshort-downloader'
  s.license       = 'MIT'
  s.metadata    = { "source_code_uri" => "https://github.com/valsztrax/yshort-downloader" }
end
