require 'spec_helper'
require 'fakefs/spec_helpers'
require 'timecop'

describe Compass::SpriteMap do
  include FakeFS::SpecHelpers

  let(:sprite_map) { self.class.describes.new(uri, options) }
  let(:options) { { :test => :test2 } }

  subject { sprite_map }

  let(:path) { 'path' }
  let(:dir) { "dir/#{name}" }
  let(:name) { 'subdir' }

  let(:sprite_path) { File.join(path, dir) }
  let(:files) { (1..3).collect { |i| File.join(sprite_path, "#{i}.png") } }
  let(:expanded_files) { files.collect { |file| File.expand_path(file) } }

  let(:configuration) { stub(:images_path => path) }
  let(:mtime) { Time.now - 30 }

  before {
    Compass.stubs(:configuration).returns(configuration)

    FileUtils.mkdir_p(sprite_path)
    Timecop.freeze(mtime) do
      files.each { |file| File.open(file, 'w') }
    end
    Timecop.return
  }

  describe '#initialize' do
    let(:uri) { 'dir/subdir/*.png' }

    its(:uri) { should == uri }
    its(:path) { should == dir }
    its(:name) { should == name }

    its(:files) { should == expanded_files }

    its(:sass_options) { should == options.merge(:filename => name, :syntax => :scss, :importer => sprite_map) }


    it "should have a correct mtime" do
      sprite_map.mtime(uri, subject.sass_options).should == mtime
    end

    it "should have a test for the sass engine" do
      pending 'sass'
    end
  end
end
