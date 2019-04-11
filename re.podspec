Pod::Spec.new do |s|
    s.name             = "re"
    s.version          = "1.1.0"
    s.summary          = "Pythonic RegEx library."
    s.homepage         = "https://meniny.cn/"
    s.social_media_url = 'https://meniny.cn/'
    s.author           = { "Elias Abel" => "admin@meniny.cn" }
    s.license          = { :type => "MIT", :file => "LICENSE.md" }
    s.source           = { :git => "https://github.com/Meniny/re.git", :tag => s.version.to_s }
    s.requires_arc     = true
    s.source_files     = 're/**/*.{swift,h}'
    s.swift_version    = '5'

    s.ios.deployment_target     = "8.0"
    s.osx.deployment_target     = "10.9"
    s.watchos.deployment_target = "2.0"
    s.tvos.deployment_target    = "9.0"
end
