#
#  Be sure to run `pod spec lint FXDatabase.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "FXDatabase"
  spec.version      = "0.1.2"
  spec.summary      = "对FMDB的封装"
  spec.homepage     = "https://github.com/feixue299/FXDatabase"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "wupengfei" => "1569485690@qq.com" }
  spec.source       = { :git => "https://github.com/feixue299/FXDatabase.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources", "Sources/**/*.{h,m}"
  spec.platform = :ios
  spec.dependency "FMDB"

end
