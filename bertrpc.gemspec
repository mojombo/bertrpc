Gem::Specification.new do |s|
  s.name = %q{bertrpc}
  s.version = "1.3.1"

  s.authors = ["Tom Preston-Werner"]
  s.date = %q{2010-02-24}
  s.email = %q{tom@mojombo.com}

  s.files = `git ls-files`.split("\n") - %w[Gemfile Gemfile.lock]
  s.test_files = `git ls-files -- test`.split("\n").select { |f| f =~ /_test.rb$/ }
  s.homepage = %q{http://github.com/github/bertrpc}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{BERTRPC is a Ruby BERT-RPC client library.}

  s.add_runtime_dependency(%q<bert>, [">= 1.1.0", "< 2.0.0"])

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "4.7.0"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
end

