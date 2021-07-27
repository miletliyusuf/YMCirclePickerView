Pod::Spec.new do |spec|

  spec.name         = "YMCirclePickerView"
  spec.version      = "1.0.4"
  spec.summary      = "HTTP Networking library written in Swift."

  spec.description  = <<-DESC
  Circled horizontal picker view. Written in Swift.
                   DESC
  spec.homepage     = "https://github.com/miletliyusuf/YMCirclePickerView"
  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Yusuf Miletli" => "miletliyusuf@gmail.com" }
  spec.social_media_url   = "https://www.linkedin.com/in/miletliyusuf/"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/miletliyusuf/YMCirclePickerView.git", :tag => "#{spec.version}" }
  spec.source_files  = "YMCirclePickerView", "YMCirclePickerView/**/*.xib", "YMCirclePickerView/**/*.swift"
  spec.resource_bundles = { 'YMCirclePickerView' => ['YMCirclePickerView/**/*.xib'] }
  spec.swift_version = "5.0"
end
