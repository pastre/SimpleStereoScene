Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "SimpleStereoScene"
s.summary = "SimpleStereoScene creates and attaches a stereographic scnscne to a view"
s.requires_arc = true

# 2
s.version = "0.3.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Bruno Pastre" => "pastre68@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/pastre/SimpleStereoScene"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/pastre/SimpleStereoScene.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.framework = "SceneKit"
s.framework = "CoreMotion"

# 8
s.source_files = "SimpleStereoScene/**/*.{swift}"

# 9
#s.resources = "SimpleStereoScene/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "5.0"

end
