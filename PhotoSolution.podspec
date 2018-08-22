Pod::Spec.new do |spec|
  spec.name             = "PhotoSolution"
  spec.version          = "0.90"
  spec.summary          = "PhotoSolution is an all-in-one photo solution for your iOS app, the UI is similar to WeChat"
  build_tag             = spec.version
  spec.homepage         = "https://github.com/Mark-Ma-1988/PhotoSolution"
  spec.license          = 'MIT'
  spec.author           = { "Mark Ma" => "maxch1988@gmail.com" }
  spec.source           = {
                          :git => "https://github.com/Mark-Ma-1988/PhotoSolution.git",
                          :tag => build_tag.to_s
                          }
  spec.platform         = :ios, '9.0'
  spec.module_name = 'PhotoSolution'
  spec.source_files     = 'PhotoSolution/*.{swift}'
  spec.swift_version = '4.1'
  spec.requires_arc = true
  spec.social_media_url = 'https://www.linkedin.com/in/xingchen-mark-ma-72a74678/'
  spec.resource_bundles = {
                            'PhotoSolution' => ['PhotoSolution/*.{xib,png,storyboard}']
                          }
end