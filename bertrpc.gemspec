Gem::Specification.new do |s|
  s.name = %q{bertrpc}
  s.version = "1.3.1"

  s.authors = ["GitHub, Inc."]
  s.date = %q{2014-08-19}
  s.email = %q{systems@github.com}

  s.files = `git ls-files`.split("\n") - %w[Gemfile Gemfile.lock]
  s.test_files = `git ls-files -- test`.split("\n").select { |f| f =~ /_test.rb$/ }
  s.homepage = %q{http://github.com/github/bertrpc}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{BERTRPC is a Ruby BERT-RPC client library.}

  s.add_runtime_dependency(%q<bert>, [">= 1.1.0", "< 2.0.0"])
end

