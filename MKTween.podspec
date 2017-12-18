Pod::Spec.new do |s|
  s.name = 'MKTween'
  s.version = '2.2'
  s.license = 'MIT'
  s.summary = 'Very simple and lightweight tween framework in Swift 4.0'
  s.description  = <<-DESC 
                   No objects/views bindings for a more flexible use. Uses CADisplayLink or NSTimer with time interval parameters. 
                   DESC
  s.homepage = 'https://github.com/kmalkic/MKTween'
  s.authors = { 'Kevin Malkic' => 'k_malkic@yahoo.fr' }
  s.source = { :git => 'https://github.com/kmalkic/MKTween.git', :tag => s.version.to_s }
  s.platform = :ios, '9.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.source_files = 'MKTween/*.swift'
  s.requires_arc = true
end