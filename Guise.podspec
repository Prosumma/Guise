Pod::Spec.new do |s|
  s.name         = "Guise"
  s.version      = "9.1"
  s.summary      = "An elegant, flexible, type-safe dependency resolution framework for Swift."
  s.description  = <<-DESC
Guise is an elegant, flexible, type-safe dependency resolution framework for Swift.
It allows caching, simplifies unit testing, and allows your application to be more loosely coupled.
                   DESC
  s.homepage     = "https://github.com/Prosumma/Guise"
  s.social_media_url = 'http://twitter.com/prosumma'
  s.license      = "MIT"
  s.author             = { "Gregory Higley" => "code@revolucent.net" }
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/Prosumma/Guise.git", :tag => s.version }
  s.source_files  = "Guise/Common"
  s.requires_arc = true
end
