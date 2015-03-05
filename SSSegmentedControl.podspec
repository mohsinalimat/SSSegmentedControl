Pod::Spec.new do |s|
  s.name         = "SSSegmentedControl"
  s.version      = "0.0.1"
  s.summary      = "Fully Customizable UISegmentedControl."
  s.homepage     = "http://github.com/StyleShare/SSSegmentedControl"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "devxoul" => "devxoul@gmail.com" }
  s.source       = { :git => "https://github.com/StyleShare/SSSegmentedControl.git" }
  s.platform     = :ios, '7.0'
  s.source_files = 'SSSegmentedControl/*.{h,m}'
  s.frameworks = 'UIKit', 'Foundation', 'QuartzCore'
  s.requires_arc = true
end
