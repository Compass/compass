require 'spec_helper'
require 'compass/sass_extensions/sprites/image'

describe Compass::SassExtensions::Sprites::Image do
  let(:sprite_filename) { 'squares/ten-by-ten.png' }
  let(:sprite_path) { File.join(images_src_path, sprite_filename) }
  let(:sprite_name) { File.basename(sprite_filename, '.png') }
  let(:image) { self.class.describes.new(File.join(sprite_filename), options)}
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
  end

  let(:options) {
    options = Object.new
    options.stub(:get_var) { |which| (which == get_var_expects) ? get_var_return : nil }
    options
  }

  describe '#repeat' do
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
    before { image.stub(:position) { stub_position } }

    let(:offset) { 100 }
    let(:stub_position) {
      stub = double
      stub.stub(:value) { offset }
      stub
    }

    context 'unitless' do
      before { stub_position.stub(:unitless?) { true } }
      before { stub_position.stub(:unit_str) { 'em' } }

      its(:offset) { should == offset }
    end

    context 'pixels' do
      before { stub_position.stub(:unitless?) { false } }
      before { stub_position.stub(:unit_str) { 'px' } }

      its(:offset) { should == offset }
    end

    context 'neither, use 0' do
      before { stub_position.stub(:unitless?) { false } }
      before { stub_position.stub(:unit_str) { 'em' } }

      its(:offset) { should == 0 }
    end
  end
end
