Pod::Spec.new do |s|
  s.name = 'MKCubeController'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'MKCubeController is used to create a rotating 3D cube navigation in Swift 2.1.'
  s.description  = <<-DESC
                    MKCubeController is used to create a rotating 3D cube navigation in Swift 2.1. (translated from @nicklockwood CubeController)
                    Here the link https://github.com/nicklockwood/CubeController 
                   DESC
  s.homepage = 'https://github.com/kmalkic/MKCubeController'
  s.authors = { 'Kevin Malkic' => 'k_malkic@yahoo.fr' }
  s.source = { :git => 'https://github.com/kmalkic/MKCubeController.git', :tag => s.version }
  s.platform = :ios, "8.0"
  s.source_files = 'MKCubeController/*.swift'
  s.requires_arc = true
end