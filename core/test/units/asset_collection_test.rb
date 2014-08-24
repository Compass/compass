#! /usr/bin/env ruby
test_directory = File.expand_path(File.dirname(__FILE__))
$: << test_directory unless $:.include? test_directory
require 'test_helper'

class AssetCollectionTest < Test::Unit::TestCase

  include Compass::Configuration
  include Compass::Core::HTTPUtil

  ABSOLUTE_COLLECTION_OPTS = {
    :root_path => "/tmp/some_assets",
    :sass_dir => "scss",
    :fonts_dir => "fnts",
    :images_dir => "imgs",
    :http_path => "/some-assets",
    :asset_host => nil,
    :asset_cache_buster => :none
  }

  RELATIVE_COLLECTION_OPTS = {
    :root_dir => "some_assets",
    :sass_dir => "scss",
    :fonts_dir => "fnts",
    :images_dir => "imgs",
    :http_dir => "some-assets",
    :asset_host => nil,
    :asset_cache_buster => :none
  }

  HTTP_RELATIVE_COLLECTION_OPTS = {
    :root_dir => "some_assets",
    :sass_dir => "scss",
    :fonts_dir => "fnts",
    :images_dir => "imgs",
    :http_fonts_dir => "hfnts",
    :http_images_dir => "himgs",
    :http_dir => "some-assets",
    :asset_host => nil,
    :asset_cache_buster => :none
  }

  HTTP_ABSOLUTE_COLLECTION_OPTS = {
    :root_dir => "some_assets",
    :sass_dir => "scss",
    :fonts_dir => "fnts",
    :images_dir => "imgs",
    :http_fonts_path => "/font-assets",
    :http_images_path => "/image-assets",
    :http_dir => "some-assets",
    :asset_host => nil,
    :asset_cache_buster => :none
  }

  def test_asset_collection_keys
    valid_sets = [ABSOLUTE_COLLECTION_OPTS, RELATIVE_COLLECTION_OPTS,
                  HTTP_RELATIVE_COLLECTION_OPTS, HTTP_ABSOLUTE_COLLECTION_OPTS]

    valid_sets.each do |v|
      AssetCollection.new(v)
    end
  end

  def test_invalid_collection_keys
    assert_raise_message(ArgumentError, "Either :root_path or :root_dir must be specified.") do
      AssetCollection.new({})
    end
  end

  def test_invalid_collection_keys
    assert_raise_message(ArgumentError, "Either :http_path or :http_dir must be specified.") do
      AssetCollection.new({:root_path => "/tmp"})
    end
  end


  def test_resolved_attributes_absolute
    collection = AssetCollection.new(ABSOLUTE_COLLECTION_OPTS)
    assert_equal "/tmp/some_assets", collection.root_path
    assert_equal "/some-assets", collection.http_path
    assert_equal "/tmp/some_assets/scss", collection.sass_path
    assert_equal "/tmp/some_assets/fnts", collection.fonts_path
    assert_equal "/tmp/some_assets/imgs", collection.images_path
    assert_equal "/some-assets/fnts", collection.http_fonts_path
    assert_equal "/some-assets/imgs", collection.http_images_path
    assert_equal nil, collection.asset_host
    assert_equal :none, collection.asset_cache_buster
  end

  def test_resolved_attributes_relative
    collection = AssetCollection.new(RELATIVE_COLLECTION_OPTS)
    assert_equal "./some_assets", collection.root_path
    assert_equal "/some-assets", collection.http_path
    assert_equal "./some_assets/scss", collection.sass_path
    assert_equal "./some_assets/fnts", collection.fonts_path
    assert_equal "./some_assets/imgs", collection.images_path
    assert_equal "/some-assets/fnts", collection.http_fonts_path
    assert_equal "/some-assets/imgs", collection.http_images_path
    assert_equal nil, collection.asset_host
    assert_equal :none, collection.asset_cache_buster
  end

  def test_resolved_attributes_http_absolute
    collection = AssetCollection.new(HTTP_ABSOLUTE_COLLECTION_OPTS)
    assert_equal "./some_assets", collection.root_path
    assert_equal "/some-assets", collection.http_path
    assert_equal "./some_assets/scss", collection.sass_path
    assert_equal "./some_assets/fnts", collection.fonts_path
    assert_equal "./some_assets/imgs", collection.images_path
    assert_equal "/font-assets", collection.http_fonts_path
    assert_equal "/image-assets", collection.http_images_path
    assert_equal nil, collection.asset_host
    assert_equal :none, collection.asset_cache_buster
  end

  def test_resolved_attributes_http_relative
    collection = AssetCollection.new(HTTP_RELATIVE_COLLECTION_OPTS)
    assert_equal "./some_assets", collection.root_path
    assert_equal "/some-assets", collection.http_path
    assert_equal "./some_assets/scss", collection.sass_path
    assert_equal "./some_assets/fnts", collection.fonts_path
    assert_equal "./some_assets/imgs", collection.images_path
    assert_equal "/some-assets/hfnts", collection.http_fonts_path
    assert_equal "/some-assets/himgs", collection.http_images_path
    assert_equal nil, collection.asset_host
    assert_equal :none, collection.asset_cache_buster
  end

  def test_resolved_attributes_absolute_default
    asset_host_proc = proc {|url| "http://something.com" }
    asset_cache_buster_proc = proc {|url, file| nil }
    Compass.configuration.asset_host(&asset_host_proc)
    Compass.configuration.asset_cache_buster(&asset_cache_buster_proc)
    collection = AssetCollection.new(:root_path => ABSOLUTE_COLLECTION_OPTS[:root_path],
                                     :http_path => ABSOLUTE_COLLECTION_OPTS[:http_path])
    assert_equal "/tmp/some_assets", collection.root_path
    assert_equal "/some-assets", collection.http_path
    assert_equal nil, collection.sass_path
    assert_equal nil, collection.fonts_path
    assert_equal nil, collection.images_path
    assert_equal nil, collection.asset_host
    assert_equal nil, collection.asset_cache_buster
  end

  def test_resolved_attributes_relative_default
    asset_host_proc = proc {|url| "http://something.com" }
    asset_cache_buster_proc = proc {|url, file| nil }
    Compass.configuration.asset_host(&asset_host_proc)
    Compass.configuration.asset_cache_buster(&asset_cache_buster_proc)
    collection = AssetCollection.new(:root_dir => RELATIVE_COLLECTION_OPTS[:root_dir],
                                     :http_dir => RELATIVE_COLLECTION_OPTS[:http_dir])
    assert_equal "./some_assets", collection.root_path
    assert_equal "/some-assets", collection.http_path
    assert_equal nil, collection.sass_path
    assert_equal nil, collection.fonts_path
    assert_equal nil, collection.images_path
    assert_equal asset_host_proc, collection.asset_host
    assert_equal asset_cache_buster_proc, collection.asset_cache_buster
  end

  def test_url_join
    assert_equal "foo/bar", url_join("foo", "bar")
    assert_equal "foo/bar/baz", url_join("foo", "bar", "baz")
    assert_equal "foo/bar", url_join("foo/", "bar")
    assert_equal "foo/bar/baz", url_join("foo/", "bar/", "baz")
  end

  def test_expand_url_path
    assert_equal "/", expand_url_path("/")
    assert_equal "/foo", expand_url_path("/foo")
    assert_equal "/foo/", expand_url_path("/foo/")
    assert_equal "/", expand_url_path("/foo/..")
    assert_equal "", expand_url_path("foo/..")
    assert_equal "d", expand_url_path("a/../b/../c/../d")
    assert_equal "d", expand_url_path("a/../b/c/../../d")
    assert_equal "a/b", expand_url_path("a//b")
    assert_equal "a/b", expand_url_path("a/./b")
    assert_raise_message(ArgumentError, "Invalid URL: .. (not enough parent directories)") do
      expand_url_path("..")
    end
    assert_raise_message(ArgumentError, "Invalid URL: a/../b/c/../../../d (not enough parent directories)") do
      expand_url_path("a/../b/c/../../../d")
    end
  end

  def test_asset_url_resolver
    fixtures_dir = File.expand_path("fixtures/asset_resolver_tests", File.dirname(__FILE__))
    configuration = Compass::Configuration::Data.new("test", :project_path => fixtures_dir, :asset_cache_buster => :none)
    configuration.extend(Compass::Configuration::Defaults)
    collection1 = Compass::Configuration::AssetCollection.new(
      {:root_dir => "asset_collection_one",
       :http_dir => "asset-collection-one",
       :fonts_dir => "fancy_fonts",
       :images_dir => "fancy_images",
       :asset_cache_buster => :none}
    )
    collection2 = Compass::Configuration::AssetCollection.new(
      {:root_dir => "asset_collection_two",
       :http_dir => "asset-collection-two",
       :fonts_dir => "more_fonts",
       :images_dir => "more_images",
       :asset_cache_buster => :none}
    )
    resolver = Compass::Core::AssetUrlResolver.new([collection1, collection2], configuration)
    assert_equal "/asset-collection-two/more_images/moreimage.jpg",
                 resolver.compute_url(:image, "moreimage.jpg")
    assert_equal "/asset-collection-one/fancy_images/image1.jpg",
                 resolver.compute_url(:image, "image1.jpg")
    assert_equal "/images/default.jpg",
                 resolver.compute_url(:image, "default.jpg")
    assert_equal "/asset-collection-two/more_fonts/morefont.ttf",
                 resolver.compute_url(:font, "morefont.ttf")
    assert_equal "/asset-collection-one/fancy_fonts/font1.ttf",
                 resolver.compute_url(:font, "font1.ttf")
    assert_equal "/fonts/default.ttf",
                 resolver.compute_url(:font, "default.ttf")
    assert_equal "/asset-collection-one/fancy_images/fancy_subdir/image2.png",
                 resolver.compute_url(:image, "fancy_subdir/image2.png")
    assert_equal "/asset-collection-one/fancy_images/image1.jpg",
                 resolver.compute_url(:image, "fancy_subdir/../image1.jpg")
    assert_equal "/asset-collection-one/fancy_images/image3.svg#something",
                 resolver.compute_url(:image, "image3.svg#something")
    assert_equal "/asset-collection-one/fancy_images/image3.svg?q=1234&s=4321#something",
                 resolver.compute_url(:image, "image3.svg?q=1234&s=4321#something")
    assert_equal "/does-not-exist/thing.jpg",
                 resolver.compute_url(:image, "/does-not-exist/thing.jpg")
    assert_equal "http://google.com/logo.png",
                 resolver.compute_url(:image, "http://google.com/logo.png")
    error_message = "Could not find doesnotexist.jpg in " +
                    "#{resolver.asset_collections.map{|ac| ac.images_path}.join(", ")}"
    assert_raise_message(Compass::Core::AssetUrlResolver::AssetNotFound, error_message) do
      resolver.compute_url(:image, "doesnotexist.jpg")
    end
  end

  def test_asset_url_resolver_with_asset_hosts_and_busters
    fixtures_dir = File.expand_path("fixtures/asset_resolver_tests", File.dirname(__FILE__))
    configuration = Compass::Configuration::Data.new("test", :project_path => fixtures_dir)
    configuration.extend(Compass::Configuration::Defaults)
    configuration.asset_host do |url|
      "http://default-server.org/"
    end
    configuration.asset_cache_buster do |url, file|
      "md5somthing"
    end
    collection1 = Compass::Configuration::AssetCollection.new(
      {:root_dir => "asset_collection_one",
       :http_dir => "asset-collection-one",
       :fonts_dir => "fancy_fonts",
       :images_dir => "fancy_images"}
    )
    collection2 = Compass::Configuration::AssetCollection.new(
      {:root_dir => "asset_collection_two",
       :http_dir => "asset-collection-two",
       :fonts_dir => "more_fonts",
       :images_dir => "more_images",
       :asset_host => proc {|url| "http://more-assets-server.com/" },
       :asset_cache_buster => method(:simple_path_buster)}
    )
    resolver = Compass::Core::AssetUrlResolver.new([collection1, collection2], configuration)
    assert_equal "http://more-assets-server.com/asset-collection-two/more_images/moreimage-md5something.jpg",
                 resolver.compute_url(:image, "moreimage.jpg")
    assert_equal "http://default-server.org/asset-collection-one/fancy_images/image1.jpg?md5somthing",
                 resolver.compute_url(:image, "image1.jpg")
    assert_equal "http://default-server.org/images/default.jpg?md5somthing",
                 resolver.compute_url(:image, "default.jpg")
    assert_equal "http://more-assets-server.com/asset-collection-two/more_fonts/morefont-md5something.ttf",
                 resolver.compute_url(:font, "morefont.ttf")
    assert_equal "http://default-server.org/asset-collection-one/fancy_fonts/font1.ttf?md5somthing",
                 resolver.compute_url(:font, "font1.ttf")
    assert_equal "http://default-server.org/fonts/default.ttf?md5somthing",
                 resolver.compute_url(:font, "default.ttf")
    assert_equal "http://default-server.org/asset-collection-one/fancy_images/fancy_subdir/image2.png?md5somthing",
                 resolver.compute_url(:image, "fancy_subdir/image2.png")
    assert_equal "http://default-server.org/asset-collection-one/fancy_images/image1.jpg?md5somthing",
                 resolver.compute_url(:image, "fancy_subdir/../image1.jpg")
    assert_equal "http://default-server.org/asset-collection-one/fancy_images/image3.svg?md5somthing#something",
                 resolver.compute_url(:image, "image3.svg#something")
    assert_equal "http://default-server.org/asset-collection-one/fancy_images/image3.svg?q=1234&s=4321&md5somthing#something",
                 resolver.compute_url(:image, "image3.svg?q=1234&s=4321#something")
    assert_equal "/does-not-exist/thing.jpg",
                 resolver.compute_url(:image, "/does-not-exist/thing.jpg")
    assert_equal "http://google.com/logo.png",
                 resolver.compute_url(:image, "http://google.com/logo.png")
    error_message = "Could not find doesnotexist.jpg in " +
                    "#{resolver.asset_collections.map{|ac| ac.images_path}.join(", ")}"
    assert_raise_message(Compass::Core::AssetUrlResolver::AssetNotFound, error_message) do
      resolver.compute_url(:image, "doesnotexist.jpg")
    end
  end

  def test_asset_url_resolver_with_asset_hosts_and_busters_when_relative
    fixtures_dir = File.expand_path("fixtures/asset_resolver_tests", File.dirname(__FILE__))
    configuration = Compass::Configuration::Data.new("test", :project_path => fixtures_dir)
    configuration.extend(Compass::Configuration::Defaults)
    configuration.asset_host do |url|
      "http://default-server.org/"
    end
    configuration.asset_cache_buster do |url, file|
      "md5somthing"
    end
    configuration.relative_assets = true
    collection1 = Compass::Configuration::AssetCollection.new(
      {:root_dir => "asset_collection_one",
       :http_dir => "asset-collection-one",
       :fonts_dir => "fancy_fonts",
       :images_dir => "fancy_images"}
    )
    collection2 = Compass::Configuration::AssetCollection.new(
      {:root_dir => "asset_collection_two",
       :http_dir => "asset-collection-two",
       :fonts_dir => "more_fonts",
       :images_dir => "more_images",
       :asset_host => proc {|url| "http://more-assets-server.com/" },
       :asset_cache_buster => method(:simple_path_buster)}
    )
    resolver = Compass::Core::AssetUrlResolver.new([collection1, collection2], configuration)
    assert_equal "../asset-collection-two/more_images/moreimage-md5something.jpg",
                 resolver.compute_url(:image, "moreimage.jpg", "/css/some-css-file.css")
    assert_equal "../asset-collection-one/fancy_images/image1.jpg?md5somthing",
                 resolver.compute_url(:image, "image1.jpg", "/css/some-css-file.css")
    assert_equal "../images/default.jpg?md5somthing",
                 resolver.compute_url(:image, "default.jpg", "/css/some-css-file.css")
    assert_equal "../asset-collection-two/more_fonts/morefont-md5something.ttf",
                 resolver.compute_url(:font, "morefont.ttf", "/css/some-css-file.css")
    assert_equal "../asset-collection-one/fancy_fonts/font1.ttf?md5somthing",
                 resolver.compute_url(:font, "font1.ttf", "/css/some-css-file.css")
    assert_equal "../fonts/default.ttf?md5somthing",
                 resolver.compute_url(:font, "default.ttf", "/css/some-css-file.css")
    assert_equal "../asset-collection-one/fancy_images/fancy_subdir/image2.png?md5somthing",
                 resolver.compute_url(:image, "fancy_subdir/image2.png", "/css/some-css-file.css")
    assert_equal "../asset-collection-one/fancy_images/image1.jpg?md5somthing",
                 resolver.compute_url(:image, "fancy_subdir/../image1.jpg", "/css/some-css-file.css")
    assert_equal "../asset-collection-one/fancy_images/image3.svg?md5somthing#something",
                 resolver.compute_url(:image, "image3.svg#something", "/css/some-css-file.css")
    assert_equal "../asset-collection-one/fancy_images/image3.svg?q=1234&s=4321&md5somthing#something",
                 resolver.compute_url(:image, "image3.svg?q=1234&s=4321#something", "/css/some-css-file.css")
    assert_equal "/does-not-exist/thing.jpg",
                 resolver.compute_url(:image, "/does-not-exist/thing.jpg", "/css/some-css-file.css")
    assert_equal "http://google.com/logo.png",
                 resolver.compute_url(:image, "http://google.com/logo.png", "/css/some-css-file.css")
    error_message = "Could not find doesnotexist.jpg in " +
                    "#{resolver.asset_collections.map{|ac| ac.images_path}.join(", ")}"
    assert_raise_message(Compass::Core::AssetUrlResolver::AssetNotFound, error_message) do
      resolver.compute_url(:image, "doesnotexist.jpg")
    end
  end

  def simple_path_buster(url_path, file)
    segments = url_path.split('/')
    base = segments.pop
    base, ext = base.split(".")
    {:path => segments.join("/") + "/" + base + "-md5something" + "." + ext }
  end

end
