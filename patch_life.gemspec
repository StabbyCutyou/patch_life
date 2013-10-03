# -*- encoding: utf-8 -*-
$: << File.expand_path('lib', File.dirname(__FILE__))

require 'version'

Gem::Specification.new do |s|
  s.name = "patch_life"
  s.version = PatchLife::Version::STRING

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stabby Cutyou"]
  s.date = Time.new.strftime("%Y-%m-%d")
  s.description = "Allows you to define a patch to ruby in a block that only gets executed if you're below the version which obsoletes the patch."

  s.files = Dir[*%w(
    patch_life.gemspec
    lib/**/*
    spec/**/*
    README.md
    LICENSE
  )]

  s.homepage = "http://github.com/StabbyCutyou/patch_life"
  s.licenses = ["Custom with a touch of MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Yells at you when you should have removed a particular patch by now"

  s.add_development_dependency("rspec")
  s.add_development_dependency("bundler")
end

