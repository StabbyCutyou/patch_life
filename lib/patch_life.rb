module PatchLife
  def define_patch_life(options={})
    raise(ArgumentError, "print_patch_warning requires a :version argument to be set") unless options[:version]
    raise(ArgumentError, "print_patch_warning requires a :patch argument to be set") unless options[:patch]
    raise(ArgumentError, "print_patch_warning requires either a :message argument, a block to yield, or both") unless options[:message] || block_given?
  
    past_due = Gem::Version.new(ruby_version) >= Gem::Version.new(options[:version]) && ruby_patch_level >= options[:patch].to_i
    Kernel.warn(options[:message]) if past_due && options[:message]
    yield if !past_due && block_given?
    #Don't want to return anything at all...
    nil
  end
  module_function :define_patch_life

  def ruby_version
    RUBY_VERSION.dup
  end
  module_function :ruby_version

  def ruby_patch_level
    RUBY_PATCHLEVEL
  end
  module_function :ruby_patch_level
end

def patch_life(options={})
  PatchLife.define_patch_life(options)
end
