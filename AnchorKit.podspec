Pod::Spec.new do |s|

  s.name         = "AnchorKit"
  s.version      = "0.4.0"
  s.summary      = "A Swifty anchor-based API for AutoLayout."

  s.description  = <<-DESC
  
  AnchorKit is a Swifty API for AutoLayout on iOS, macOS, and tvOS.
  Create constraints quickly and efficiently with no black box magic underneath the hood.
  Also provides several extensions on `NSLayoutConstraint`. Works with both views and layout guides.

  DESC

  s.license   = { :type => "MIT", :file => "LICENSE" }
  s.homepage  = "https://github.com/Weebly/AnchorKit.git"
  s.author    = { "Eddie Kaiger" => "eddie.kaiger@weebly.com" }

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "git@github.intern.weebly.net:Weebly-iOS/AnchorKit.git", :tag => "v0.4.0" }
  s.requires_arc = true
  s.source_files = "AnchorKit/*.swift"

end
