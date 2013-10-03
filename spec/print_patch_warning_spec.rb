require 'spec_helper'

describe PrintPatchWarning do
  before(:each) do
    #Don't wanna actually fire it...
    Kernel.stub(:warn)
  end

  context "when being defined" do
    let (:version) {"1.0.0"}
    let (:patch) {1}
    let (:message) {"You're outdated"}
    it "requires a version to be delcared" do
      expect {subject.print_patch_warning}.to raise_error(ArgumentError)
    end

    it "requires a patch level to be declared" do
      expect {subject.print_patch_warning(:version=>version)}.to raise_error(ArgumentError)
    end

    it "requires a message when no block has been yielded" do
      expect {subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message)}.not_to raise_error
    end

    it "requires a block when no message was declared" do
      expect {subject.print_patch_warning(:version=>version, :patch=>patch) {nil} }.not_to raise_error
    end

    it "allows both a message and a block at the same time" do
      expect {subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message) {nil} }.not_to raise_error
    end
  end

  context "when comparing ruby versions" do
    context "and the current ruby version is less than the declared version" do
      let (:version) {"9.9.9"}
      let (:patch) {999}
      let (:message) {"You're outdated"}

      it "will not print a message if defined" do
        Kernel.should_not_receive(:warn).with(message)
        subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message) {nil}
      end

      it "will yield a block if given" do
        block_called = false
        subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message) {block_called=true}
        block_called.should == true
      end
    end

    context "and the current ruby version is equal to the declared version" do
      let (:version) {RUBY_VERSION.dup}
      let (:patch) {RUBY_PATCHLEVEL}
      let (:message) {"You're outdated"}
      
      it "will print a message if defined" do
        Kernel.should_receive(:warn).with(message)
        subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message) {nil}
      end

      it "will not yield a block if given" do
        block_called = false
        subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message) {block_called=true}
        block_called.should == false
      end
    end

    context "and the current ruby version is greater than the declared version" do
      let (:version) {"1.0.0"}
      let (:patch) {1}
      let (:message) {"You're outdated"}

      it "will print a message if defined" do
        Kernel.should_receive(:warn).with(message)
        subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message) {nil}
      end

      it "will not yield a block if given" do
        block_called = false
        subject.print_patch_warning(:version=>version, :patch=>patch, :message=>message) {block_called=true}
        block_called.should == false
      end
    end
  end
end