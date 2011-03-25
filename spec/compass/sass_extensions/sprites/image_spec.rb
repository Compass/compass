require 'spec_helper'
require 'compass/sass_extensions/sprites/image'

describe Compass::SassExtensions::Sprites::Image do
  let(:sprite_filename) { 'squares/ten-by-ten.png' }
  let(:sprite_path) { File.join(images_src_path, sprite_filename) }
  let(:sprite_name) { File.basename(sprite_filename, '.png') }
  let(:parent) do
    mock
  end
  before do
    parent.stubs(:image_for).with('ten-by-ten').returns(image)
    parent.stubs(:image_for).with('ten-by-ten_hover').returns(hover_image)
  end
  let(:image) { self.class.describes.new(parent, File.join(sprite_filename), options)}
  let(:hover_image) { self.class.describes.new(parent, File.join('selectors/ten-by-ten_hover.png'), options)}
  let(:digest) { Digest::MD5.file(sprite_path).hexdigest }
  subject { image }

  before {
    file = StringIO.new("images_path = #{images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
  }

  describe '#initialize' do
    its(:name) { should == sprite_name }
    its(:file) { should == sprite_path }
    its(:relative_file) { should == sprite_filename }
    its(:width) { should == 10 }
    its(:height) { should == 10 }
    its(:digest) { should == digest }
    its(:top) { should == 0 }
    its(:left) { should == 0 }
  end

  let(:get_var_expects) { nil }
  let(:get_var_return) { nil }

  let(:options) {
    options = mock
    options.stubs(:get_var).with(anything).returns(nil)
    options.stubs(:get_var).with(get_var_expects).returns(get_var_return)
    options
  }
  
  describe '#parent' do
    context '_hover' do
      subject { hover_image }
      its(:parent) { should == image }
    end
    context 'no parent' do
      subject { image }
      its(:parent) { should be_nil }
    end
  end
  
  describe '#repeat' do
    let(:type) { nil }
    let(:get_var_return) { OpenStruct.new(:value => type) }

    context 'specific image' do
      let(:type) { 'specific' }
      let(:get_var_expects) { "#{sprite_name}-repeat" }

      its(:repeat) { should == type }
    end

    context 'global' do
      let(:type) { 'global' }
      let(:get_var_expects) { 'repeat' }

      its(:repeat) { should == type }
    end

    context 'default' do
      let(:get_var_expects) { nil }

      its(:repeat) { should == "no-repeat" }
    end
  end

  describe '#position' do
    let(:type) { nil }
    let(:get_var_return) { type }

    context 'specific image' do
      let(:type) { 'specific' }
      let(:get_var_expects) { "#{sprite_name}-position" }

      its(:position) { should == type }
    end

    context 'global' do
      let(:type) { 'global' }
      let(:get_var_expects) { 'position' }

      its(:position) { should == type }
    end

    context 'default' do
      let(:get_var_expects) { nil }

      its(:position) { should == Sass::Script::Number.new(0, ["px"]) }
    end
  end

  describe '#spacing' do
    let(:type) { nil }
    let(:get_var_return) { OpenStruct.new(:value => type) }

    context 'specific image' do
      let(:type) { 'specific' }
      let(:get_var_expects) { "#{sprite_name}-spacing" }

      its(:spacing) { should == type }
    end

    context 'global' do
      let(:type) { 'global' }
      let(:get_var_expects) { 'spacing' }

      its(:spacing) { should == type }
    end

    context 'default' do
      let(:get_var_expects) { nil }

      its(:spacing) { should == Sass::Script::Number.new(0).value }
    end
  end

  describe '#offset' do
    before { image.stubs(:position).returns(stub_position) }

    let(:offset) { 100 }
    let(:stub_position) {
      stub(:value => offset)
    }

    context 'unitless' do
      before { stub_position.stubs(:unitless?).returns(true) }
      before { stub_position.stubs(:unit_str).returns('em') }

      its(:offset) { should == offset }
    end

    context 'pixels' do
      before { stub_position.stubs(:unitless?).returns(false) }
      before { stub_position.stubs(:unit_str).returns('px') }

      its(:offset) { should == offset }
    end

    context 'neither, use 0' do
      before { stub_position.stubs(:unitless?).returns(false) }
      before { stub_position.stubs(:unit_str).returns('em') }

      its(:offset) { should == 0 }
    end
  end
end
