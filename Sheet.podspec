Pod::Spec.new do |s|
  s.name         = "Sheet"
  s.version      = "0.1.0"
  s.swift_version = '4.0'
  s.summary      = "Navigationable Action Sheet"
  s.description  = "💦 Navigable custom action sheet like Flipboard"
  s.homepage     = "https://github.com/ParkGwangBeom/Sheet"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "gwangbeom" => "battlerhkqo@naver.com" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/ParkGwangBeom/Sheet.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
