require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Lemonade do

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
    Lemonade.stub(:images_path).and_return('image_path')
    File.stub!(:ctime => Time.parse('2010-01-01 12:00'))
  end

  ###

  describe '#remember_sprite_info' do
    subject { Lemonade }

    it 'should save sprite info into a file' do
      File.should_receive(:open).with(File.join('image_path', 'the_sprite.sprite_info.yml'), 'w').and_yield(@file)
      @file.should_receive(:<<)
      subject.remember_sprite_info!('the_sprite', @sprite)
    end
  end

  ###

  describe '#sprite_changed?' do
    subject { Lemonade }

    it 'should be false if nothing changed' do
      File.should_receive(:open).and_yield(@file)
      subject.remember_sprite_info!('the sprite', @sprite)
      subject.sprite_changed?('the sprite', @sprite).should be_false
    end

    it 'should be true if the sprite info has changed' do
      File.should_receive(:open).and_yield(@file)
      subject.remember_sprite_info!('the sprite', @sprite)
      @sprite[:info] = 'changed info'
      subject.sprite_changed?('the sprite', @sprite).should be_true
    end

    it 'should be true if the images changed' do
      File.should_receive(:open).and_yield(@file)
      subject.remember_sprite_info!('the sprite', @sprite)
      @sprite[:images] = []
      subject.sprite_changed?('the sprite', @sprite).should be_true
    end

    it 'should be true if a images timestamp changed' do
      File.should_receive(:open).and_yield(@file)
      subject.remember_sprite_info!('the sprite', @sprite)
      File.stub!(:ctime => Time.now)
      subject.sprite_changed?('the sprite', @sprite).should be_true
    end

  end

end
