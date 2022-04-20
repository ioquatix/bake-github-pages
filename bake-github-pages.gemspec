
require_relative "lib/bake/github/pages/version"

Gem::Specification.new do |spec|
	spec.name = "bake-github-pages"
	spec.version = Bake::GitHub::Pages::VERSION
	
	spec.summary = "Publish to GitHub pages."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/bake-github-pages"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob('{bake,lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 2.3.0"
	
	spec.add_dependency "build-files", "~> 1.0"
	
	spec.add_development_dependency "sus"
end
