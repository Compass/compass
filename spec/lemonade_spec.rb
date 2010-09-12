require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Compass::Sprites do

  before :each do
    @sprite = {
      :info => 'info',
      :images => [
        { :file => 'file1' },
        { :file => 'file2' },
      ]
    }

    @file = ""
    File.stub!(:read => @file)
    Compass::Sprites.stub(:images_path).and_return('image_path')
    File.stub!(:ctime => Time.parse('2010-01-01 12:00'))
  end

  ###

  describe '#remember_sprite_info' do

    subject { Compass::Sprites }

    before :each do
      @options = {
        :cache_store => Sass::InMemoryCacheStore.new
      }
    end

    it 'should save sprite info to the sass cache' do
      subject.remember_sprite_info!('the_sprite', @sprite, @options)
      @options[:cache_store].retrieve('_the_sprite_data', "")[:sprite].should == @sprite
    end
  end

  ###

  describe '#sprite_changed?' do

    subject { Compass::Sprites }

    before :each do
      @options = {
        :cache_store => Sass::InMemoryCacheStore.new
      }
    end

    it 'should be false if nothing changed' do
      subject.remember_sprite_info!('the sprite', @sprite, @options)
      subject.sprite_changed?('the sprite', @sprite, @options).should be_false
    end

    it 'should be true if the sprite info has changed' do
      subject.remember_sprite_info!('the sprite', @sprite, @options)
      @sprite[:info] = 'changed info'
      subject.sprite_changed?('the sprite', @sprite, @options).should be_true
    end

    it 'should be true if the images changed' do
      subject.remember_sprite_info!('the sprite', @sprite, @options)
      @sprite[:images] = []
      subject.sprite_changed?('the sprite', @sprite, @options).should be_true
    end

    it 'should be true if a images timestamp changed' do
      subject.remember_sprite_info!('the sprite', @sprite, @options)
      File.stub!(:ctime => Time.now)
      subject.sprite_changed?('the sprite', @sprite, @options).should be_true
    end

  end

end
