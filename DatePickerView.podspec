Pod::Spec.new do |s|
  s.name = "DatePickerView"
  s.version = "1.0.0"
  s.summary = "It is a library that handles UIDatePicker easily."
  s.homepage = "https://github.com/tomoponzoo/DatePickerView"
  s.license = "MIT"
  s.social_media_url = "http://twitter.com/tomoponzoo"
  s.authors = { "tomoponzoo" => "tomoponzoo@gmail.com" }
  s.source = { :git => "https://github.com/tomoponzoo/DatePickerView.git", :tag => s.version }

  s.ios.deployment_target = "9.0"

  s.source_files  = "Classes/*.swift"
end
