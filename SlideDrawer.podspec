#
# Be sure to run `pod lib lint SlideDrawer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SlideDrawer'
  s.version          = '2.0.0'
  s.summary          = 'A lightweight, no intrusion，one line code to use, Slide Drawer written Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A lightweight, no intrusion，one line code to use, Slide Drawer written Swift. Do not need to set up leftviewcontroller and rightviewcontroller.
                       DESC

  s.homepage         = 'https://github.com/Bruce-pac/SlideDrawer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bruce-pac' => 'Bruce_pac312@foxmail.com' }
  s.source           = { :git => 'https://github.com/Bruce-pac/SlideDrawer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_versions = [ "5.0", "4.2" ]

  s.source_files = 'SlideDrawer/Classes/**/*'

end
