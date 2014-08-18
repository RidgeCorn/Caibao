Pod::Spec.new do |s|
  s.name         = "Caibao"
  s.version 	 = "0.0.1"
  s.summary      = "An easy way to store data."
  s.homepage     = "https://github.com/RidgeCorn/Caibao"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors	 = { "Looping" => "www.looping@gmail.com" }

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'

  s.source       = { :git => "https://github.com/RidgeCorn/Caibao.git", :tag => s.version.to_s }
  s.source_files  = 'Caibao/**/*.{h,m}'

  s.requires_arc = true

  s.dependency 'Objective-LevelDB'
end
