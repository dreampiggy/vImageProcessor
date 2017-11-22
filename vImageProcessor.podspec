#
# Be sure to run `pod lib lint vImageProcessor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'vImageProcessor'
  s.version          = '0.1.0'
  s.summary          = "Image process using Apple's vImage framework"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/dreampiggy/vImageProcessor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dreampiggy' => 'lizhuoli@bytedance.com' }
  s.source           = { :git => 'https://github.com/dreampiggy/vImageProcessor.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.osx.deployment_target = '10.8'
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'vImageProcessor/Classes/**/*'
  s.frameworks = 'Foundation', 'Accelerate', 'CoreGraphics'
  s.dependency 'libextobjc'
end
