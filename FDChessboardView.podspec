Pod::Spec.new do |s|
  s.name = 'FDChessboardView'
  s.version = '2.0.0'
  s.license = 'MIT'
  s.summary = 'A view controller for chess boards'
  s.homepage = 'https://github.com/fulldecent/FDChessboardView'
  s.authors = { 'William Entriken' => 'github.com@phor.net' }
  s.source = { :git => 'https://github.com/fulldecent/FDChessboardView.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*.swift'
  s.resource_bundles = {
    'FDChessboardView' => ['Resources/**/*.{png}']
  }
  s.swift_version = '5.0'
end
