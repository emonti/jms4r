# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jms4r}
  s.version = "0.2.0"
  s.platform = %q{java}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Monti"]
  s.date = %q{2009-12-23}
  s.description = %q{A generalized JMS abstraction library for JRuby}
  s.email = %q{emonti@matasano.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "jms4r.gemspec",
     "lib/jms4r.rb",
     "lib/jms4r/browser.rb",
     "lib/jms4r/listener.rb",
     "lib/jms4r/message.rb",
     "lib/jms4r/receiver.rb",
     "lib/jms4r/sender.rb",
     "lib/jms4r/session.rb",
     "samples/activemq/activemq.rb",
     "samples/activemq/amq_slurp",
     "test/jms4r_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/emonti/jms4r}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A generalized JMS abstraction library for JRuby}
  s.test_files = [
    "test/jms4r_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
