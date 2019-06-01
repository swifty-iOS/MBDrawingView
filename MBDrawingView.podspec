Pod::Spec.new do |s|
    s.name = 'MBDrawingView'
    s.version = '1.0'
    s.summary = 'Free hand drawing iOS UIView with multilsize and mutlicolor drawing and convert tit to image.'
    s.homepage = 'https://github.com/swifty-iOS/MBDrawingView'
    s.license = 'MIT'
    s.author = { 'Swifty-iOS' => 'manishej004@gmail.com' }
    s.ios.deployment_target = '10.0'
    s.source= { :git => 'https://github.com/swifty-iOS/MBDrawingView.git', :tag => s.version }
    s.source_files = 'Source/*.swift'
    s.swift_version = '5.0'
end