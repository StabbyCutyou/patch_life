module PatchLife
  def define_patch_life(options={}, &blk)
    raise(ArgumentError, "define_patch requires a :version argument to be set") unless options[:version]
    raise(ArgumentError, "define_patch requires a :patch argument to be set") unless options[:patch]
    raise(ArgumentError, "define_patch requires either a :message argument, a block to yield, or both") unless options[:message] || block_given?
  
    past_due_version = Gem::Version.new(ruby_version) > Gem::Version.new(options[:version])
    equivalent_version = Gem::Version.new(ruby_version) == Gem::Version.new(options[:version])
    past_due_patch = ruby_patch_level >= options[:patch].to_i 
    past_due = past_due_version || (equivalent_version && past_due_patch)

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

def define_patch(options={}, &blk)
  PatchLife.define_patch_life(options, &blk)
end
