#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appmetrica.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appmetrica'
  s.version          = '0.1.0'
  s.summary          = 'AppMetrica SDK for Flutter'

  s.homepage         = 'https://appmetrica.yandex.com/'
  s.license          = { :type => 'PROPRIETARY', :file => '../LICENSE' }
  s.authors          = { "Yandex LLC" => "appmetrica@yandex-team.com" }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'AppMetrica/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h', 'AppMetrica/*.h'
  s.dependency 'Flutter'
  s.dependency 'YandexMobileMetrica', '~> 4.2'
  s.static_framework = true
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
