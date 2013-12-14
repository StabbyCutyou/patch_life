require 'spec_helper'

describe PatchLife do
  before(:each) do
    #Don't wanna actually fire it...
    Kernel.stub(:warn)
  end

  context "when being defined" do
    # Cannot rely on "let" statements here to DRY up arguments
    # Scope around applying patches uses instance_eval, so the "let"s won't be in scope
    it "requires a version to be delcared" do
      expect {
        PatchLife.define_patch do end
      }.to raise_error(ArgumentError)
    end

    it "requires a patch level to be declared" do
      expect {
        PatchLife.define_patch do
          version     "1.0.0"
        end
      }.to raise_error(ArgumentError)
    end

    it "requires a message when no patch_to_apply has been provided" do
      expect {
        PatchLife.define_patch do
          version     "1.0.0"
          patch_level  1
          message     "You're outdated"
        end
      }.not_to raise_error
    end

    it "requires a block when no message was declared" do
      expect {
        PatchLife.define_patch do
          version         "1.0.0"
          patch_level     1
          patch_to_apply  {nil}
        end
      }.not_to raise_error
    end

    it "allows both a message and a block at the same time" do
      expect {
        PatchLife.define_patch do
          version         "1.0.0"
          patch_level      1
          message         "You're outdated"
          patch_to_apply  {nil}
        end
      }.not_to raise_error
    end
  end

  context "when comparing ruby versions" do
    context "and the current ruby version is less than the declared version" do
      context "and the current ruby patch level is less than the declared patch" do
        it "will not print a message if defined" do
          Kernel.should_not_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version         "9.9.9"
            patch_level     999
            message         "You're outdated"
            patch_to_apply  {nil}
          end
        end
  
        it "will yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version         "9.9.9"
            patch_level     999
            message         "You're outdated"
            patch_to_apply   {block_called=true}
          end
          block_called.should == true
        end
      end

      context "and the current ruby patch level is equal to the declared patch" do
        it "will not print a message if defined" do
          Kernel.should_not_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version         "9.9.9"
            patch_level     RUBY_PATCHLEVEL
            message         "You're outdated"
            patch_to_apply  {nil}
          end
        end
  
        it "will yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version         "9.9.9"
            patch_level     RUBY_PATCHLEVEL
            message         "You're outdated"
            patch_to_apply  { block_called = true }
          end
          block_called.should == true
        end
      end

      context "and the current ruby patch level is greater than the declared patch" do
        let (:patch) {0}
        it "will not print a message if defined" do
          Kernel.should_not_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version           "9.9.9"
            patch_level       0
            message           "You're outdated"
            patch_to_apply    {nil}
          end
        end
  
        it "will yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version           "9.9.9"
            patch_level       0
            message           "You're outdated"
            patch_to_apply     { block_called = true }
          end
          block_called.should == true
        end
      end
    end

    context "and the current ruby version is equal to the declared version" do
      context "and the current ruby patch level is less than the declared patch" do
        it "will not print a message if defined" do
          Kernel.should_not_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version           RUBY_VERSION.dup
            patch_level       999
            message           "You're outdated"
            patch_to_apply    {nil}
          end
        end
  
        it "will yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version           RUBY_VERSION.dup
            patch_level       999
            message           "You're outdated"
            patch_to_apply    {block_called=true}
          end
          block_called.should == true
        end
      end

      context "and the current ruby patch level is equal to the declared patch" do
        let (:patch) {RUBY_PATCHLEVEL}
        it "will print a message if defined" do
          Kernel.should_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version           RUBY_VERSION.dup
            patch_level       RUBY_PATCHLEVEL
            message           "You're outdated"
            patch_to_apply    {nil}
          end
        end
  
        it "will not yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version           RUBY_VERSION.dup
            patch_level       RUBY_PATCHLEVEL
            message           "You're outdated"
            patch_to_apply    { puts "hey";block_called=true}
          end
          block_called.should == false
        end
      end

      context "and the current ruby patch level is greater than the declared patch" do
        let (:patch) {0}
        it "will print a message if defined" do
          Kernel.should_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version           RUBY_VERSION.dup
            patch_level       0
            message           "You're outdated"
            patch_to_apply    {nil}
          end
        end
  
        it "will not yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version           RUBY_VERSION.dup
            patch_level       0
            message           "You're outdated"
            patch_to_apply    {block_called=true}
          end
          block_called.should == false
        end
      end
    end

    context "and the current ruby version is greater than the declared version" do
      let (:version) {"1.0.0"}
      let (:message) {"You're outdated"}

      context "and the current ruby patch level is less than the declared patch" do
        let(:patch) {999}
        it "will print a message if defined" do
          Kernel.should_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version           "1.0.0"
            patch_level       999
            message           "You're outdated"
            patch_to_apply    {nil}
          end
        end
  
        it "will not yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version           "1.0.0"
            patch_level       999
            message           "You're outdated"
            patch_to_apply    {block_called=true}
          end
          block_called.should == false
        end
      end

      context "and the current ruby patch level is equal to the declared patch" do
        let (:patch) {RUBY_PATCHLEVEL}
        it "will print a message if defined" do
          Kernel.should_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version           "1.0.0"
            patch_level       RUBY_PATCHLEVEL
            message           "You're outdated"
            patch_to_apply    {nil}
          end
        end
  
        it "will not yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version           "1.0.0"
            patch_level       RUBY_PATCHLEVEL
            message           "You're outdated"
            patch_to_apply    {block_called=true}
          end
          block_called.should == false
        end
      end

      context "and the current ruby patch level is greater than the declared patch" do
        let (:patch) {0}
        it "will print a message if defined" do
          Kernel.should_receive(:warn).with("You're outdated")
          PatchLife.define_patch do
            version           "1.0.0"
            patch_level       0
            message           "You're outdated"
            patch_to_apply    {nil}
          end
        end
  
        it "will not yield a block if given" do
          block_called = false
          PatchLife.define_patch do
            version           "1.0.0"
            patch_level       0
            message           "You're outdated"
            patch_to_apply    {block_called=true}
          end
          block_called.should == false
        end
      end
    end
  end
end