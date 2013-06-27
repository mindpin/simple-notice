# coding: utf-8
Gem::Specification.new do |s|
  s.name = 'simple-notice'
  s.version = '0.0.0'
  s.platform = Gem::Platform::RUBY
  s.date = '2013-06-26'
  s.summary = 'simple-notice'
  s.description = 'simple-notice'
  s.authors = ['ben7th', 'fushang318']
  s.email = 'ben7th@sina.com'
  s.homepage = 'https://github.com/mindpin/simple-notice'
  s.licenses = 'MIT'
  s.files = Dir.glob("lib/**/*") + %w(README.md)
  s.require_paths = ['lib']

  s.add_dependency('sidekiq', '2.8.0')
  s.add_dependency('sidekiq-limit_fetch', '1.4')
end
