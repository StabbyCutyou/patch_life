require 'patch_life/patch'
class PatchLife
  def self.define_patch(&blk)
    PatchLife::Patch.new(&blk)
  end
end