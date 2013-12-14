class PatchLife
  class Patch
    def initialize(&blk)
      @patch_to_apply = nil
      instance_eval &blk

      raise(ArgumentError, "Patches require a version to be set") unless @version
      raise(ArgumentError, "Patches require a patch_level argument to be set") unless @patch_level
      raise(ArgumentError, "Patches require either a message, a block to apply the patch with, or both") unless @message || @patch_to_apply

      past_due_version = Gem::Version.new(self.class.ruby_version) > Gem::Version.new(@version)
      equivalent_version = Gem::Version.new(self.class.ruby_version) == Gem::Version.new(@version)
      past_due_patch = self.class.ruby_patch_level >= @patch_level.to_i 
      past_due = past_due_version || (equivalent_version && past_due_patch)
  
      Kernel.warn(@message) if past_due && @message
      apply_patch if !past_due && has_patch?
    end

    def self.ruby_version
      RUBY_VERSION.dup
    end

    def self.ruby_patch_level
      RUBY_PATCHLEVEL
    end

    def apply_patch
      @patch_to_apply.call if @patch_to_apply
    end

    def has_patch?
      @patch_to_apply ? true : false
    end

    def version(version)
      @version = version
    end

    def patch_level(patch)
      @patch_level = patch
    end

    def patch_to_apply(&blk)
      @patch_to_apply = blk
    end

    def message(message)
      @message = message
    end
  end
end