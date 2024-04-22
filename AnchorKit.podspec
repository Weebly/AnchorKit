Pod::Spec.new do |s|

  s.name         = "AnchorKit"
  s.version      = "3.0.3"
  s.summary      = "A Swifty anchor-based API for AutoLayout."

  s.description  = <<-DESC
  
  AnchorKit is a Swifty API for AutoLayout on iOS, macOS, and tvOS.
  Create constraints quickly and efficiently with no black box magic underneath the hood.
  Also provides several extensions on `NSLayoutConstraint`. Works with both views and layout guides.

  DESC

  s.license   = { :type => "MIT", :file => "LICENSE" }
  s.homepage  = "https://github.com/Weebly/AnchorKit.git"
  s.author    = { "Jace Conflenti" => "jace@squaruep.com" }

  s.ios.deployment_target = "12.0"
  s.osx.deployment_target = "10.13"
  s.tvos.deployment_target = "12.0"

  s.source       = { :git => "https://github.com/Weebly/AnchorKit.git", :tag => "v3.0.3" }
  s.resource_bundles = {'AnchorKit_privacy' => ['PrivacyInfo.xcprivacy']}
  s.requires_arc = true
  s.source_files = "AnchorKit/Source/*.swift"
  s.swift_version = "5.0"

end
