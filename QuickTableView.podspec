Pod::Spec.new do |s|
  s.name             = "QuickTableView"
  s.version          = "0.1.0"
  s.summary          = "A short description of QuickTableView."

  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/lionheart/QuickTableView"
  s.license          = 'MIT'
  s.author           = { "Dan Loewenherz" => "dloewenherz@gmail.com" }
  s.source           = { :git => "https://github.com/lionheart/QuickTableView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lionheartsw'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit'
  s.dependency 'LionheartTableViewCells'
  s.dependency 'KeyboardAdjuster'
end
