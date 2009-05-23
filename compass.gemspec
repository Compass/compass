# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{compass}
  s.version = "0.6.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Eppstein"]
  s.date = %q{2009-05-23}
  s.default_executable = %q{compass}
  s.description = %q{Compass is a Sass-based Stylesheet Framework that streamlines the creation and maintainance of CSS.}
  s.email = %q{chris@eppsteins.net}
  s.executables = ["compass"]
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "CHANGELOG.markdown",
    "README.markdown",
    "Rakefile",
    "VERSION.yml",
    "bin/compass",
    "examples/blueprint_default/config.rb",
    "examples/blueprint_default/images/grid.png",
    "examples/blueprint_default/index.html",
    "examples/blueprint_default/parts/elements.html",
    "examples/blueprint_default/parts/forms.html",
    "examples/blueprint_default/parts/grid.html",
    "examples/blueprint_default/parts/test-small.jpg",
    "examples/blueprint_default/parts/test.jpg",
    "examples/blueprint_default/parts/valid.png",
    "examples/blueprint_default/src/ie.sass",
    "examples/blueprint_default/src/print.sass",
    "examples/blueprint_default/src/screen.sass",
    "examples/blueprint_plugins/config.rb",
    "examples/blueprint_plugins/images/buttons/cross.png",
    "examples/blueprint_plugins/images/buttons/key.png",
    "examples/blueprint_plugins/images/buttons/tick.png",
    "examples/blueprint_plugins/images/grid.png",
    "examples/blueprint_plugins/images/link_icons/doc.png",
    "examples/blueprint_plugins/images/link_icons/email.png",
    "examples/blueprint_plugins/images/link_icons/external.png",
    "examples/blueprint_plugins/images/link_icons/feed.png",
    "examples/blueprint_plugins/images/link_icons/im.png",
    "examples/blueprint_plugins/images/link_icons/pdf.png",
    "examples/blueprint_plugins/images/link_icons/visited.png",
    "examples/blueprint_plugins/images/link_icons/xls.png",
    "examples/blueprint_plugins/images/test-small.jpg",
    "examples/blueprint_plugins/images/test.jpg",
    "examples/blueprint_plugins/images/valid.png",
    "examples/blueprint_plugins/index.html",
    "examples/blueprint_plugins/plugins/buttons.html",
    "examples/blueprint_plugins/plugins/fancy_type.html",
    "examples/blueprint_plugins/plugins/link_icons.html",
    "examples/blueprint_plugins/plugins/rtl.html",
    "examples/blueprint_plugins/src/buttons.sass",
    "examples/blueprint_plugins/src/ie.sass",
    "examples/blueprint_plugins/src/link_icons.sass",
    "examples/blueprint_plugins/src/print.sass",
    "examples/blueprint_plugins/src/rtl_screen.sass",
    "examples/blueprint_plugins/src/screen.sass",
    "examples/blueprint_scoped/src/ie.sass",
    "examples/blueprint_scoped/src/print.sass",
    "examples/blueprint_scoped/src/screen.sass",
    "examples/blueprint_scoped_form/src/ie.sass",
    "examples/blueprint_scoped_form/src/print.sass",
    "examples/blueprint_scoped_form/src/screen.sass",
    "examples/blueprint_semantic/config.rb",
    "examples/blueprint_semantic/images/grid.png",
    "examples/blueprint_semantic/index.html",
    "examples/blueprint_semantic/parts/fancy_type.html",
    "examples/blueprint_semantic/parts/liquid.html",
    "examples/blueprint_semantic/parts/test-small.jpg",
    "examples/blueprint_semantic/parts/test.jpg",
    "examples/blueprint_semantic/parts/valid.png",
    "examples/blueprint_semantic/src/ie.sass",
    "examples/blueprint_semantic/src/liquid.sass",
    "examples/blueprint_semantic/src/print.sass",
    "examples/blueprint_semantic/src/screen.sass",
    "examples/compass/compass.html",
    "examples/compass/config.rb",
    "examples/compass/images/blue_arrow.gif",
    "examples/compass/src/compass.sass",
    "examples/compass/src/sticky_footer.sass",
    "examples/compass/src/utilities.sass",
    "examples/compass/sticky_footer.html.haml",
    "examples/compass/utilities.html.haml",
    "examples/logo/logo.html",
    "examples/logo/src/ie.sass",
    "examples/logo/src/print.sass",
    "examples/logo/src/screen.sass",
    "examples/yui/divisions.html.haml",
    "examples/yui/index.html.haml",
    "examples/yui/src/screen.sass",
    "examples/yui/sub_divisions.html.haml",
    "examples/yui/templates.html.haml",
    "examples/yui/test.jpg",
    "examples/yui/typography.html.haml",
    "lib/compass.rb",
    "lib/compass/actions.rb",
    "lib/compass/commands/base.rb",
    "lib/compass/commands/create_project.rb",
    "lib/compass/commands/generate_grid_background.rb",
    "lib/compass/commands/installer_command.rb",
    "lib/compass/commands/list_frameworks.rb",
    "lib/compass/commands/print_version.rb",
    "lib/compass/commands/project_base.rb",
    "lib/compass/commands/stamp_pattern.rb",
    "lib/compass/commands/update_project.rb",
    "lib/compass/commands/validate_project.rb",
    "lib/compass/commands/watch_project.rb",
    "lib/compass/commands/write_configuration.rb",
    "lib/compass/compiler.rb",
    "lib/compass/configuration.rb",
    "lib/compass/core_ext.rb",
    "lib/compass/dependencies.rb",
    "lib/compass/errors.rb",
    "lib/compass/exec.rb",
    "lib/compass/frameworks.rb",
    "lib/compass/grid_builder.rb",
    "lib/compass/installers.rb",
    "lib/compass/installers/base.rb",
    "lib/compass/installers/manifest.rb",
    "lib/compass/installers/rails.rb",
    "lib/compass/installers/stand_alone.rb",
    "lib/compass/logger.rb",
    "lib/compass/merb.rb",
    "lib/compass/test_case.rb",
    "lib/compass/validate/COPYRIGHT.html",
    "lib/compass/validate/JIGSAW_COPYRIGHT",
    "lib/compass/validate/README.html",
    "lib/compass/validate/XERCES_COPYING.txt",
    "lib/compass/validate/css-validator-javadoc.jar",
    "lib/compass/validate/css-validator.jar",
    "lib/compass/validate/jigsaw.jar",
    "lib/compass/validate/xerces.jar",
    "lib/compass/validator.rb",
    "lib/compass/version.rb",
    "lib/sass_extensions.rb",
    "test/command_line_test.rb",
    "test/compass_test.rb",
    "test/configuration_test.rb",
    "test/fixtures/stylesheets/blueprint/config.rb",
    "test/fixtures/stylesheets/blueprint/css/typography.css",
    "test/fixtures/stylesheets/blueprint/sass/ie.sass",
    "test/fixtures/stylesheets/blueprint/sass/print.sass",
    "test/fixtures/stylesheets/blueprint/sass/screen.sass",
    "test/fixtures/stylesheets/blueprint/sass/typography.sass",
    "test/fixtures/stylesheets/compass/config.rb",
    "test/fixtures/stylesheets/compass/css/layout.css",
    "test/fixtures/stylesheets/compass/css/print.css",
    "test/fixtures/stylesheets/compass/css/reset.css",
    "test/fixtures/stylesheets/compass/css/utilities.css",
    "test/fixtures/stylesheets/compass/sass/layout.sass",
    "test/fixtures/stylesheets/compass/sass/print.sass",
    "test/fixtures/stylesheets/compass/sass/reset.sass",
    "test/fixtures/stylesheets/compass/sass/utilities.sass",
    "test/fixtures/stylesheets/yui/config.rb",
    "test/fixtures/stylesheets/yui/css/mixins.css",
    "test/fixtures/stylesheets/yui/sass/base.sass",
    "test/fixtures/stylesheets/yui/sass/fonts.sass",
    "test/fixtures/stylesheets/yui/sass/grids.sass",
    "test/fixtures/stylesheets/yui/sass/mixins.sass",
    "test/sass_extensions_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://compass-style.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{compass}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A Real Stylesheet Framework}
  s.test_files = [
    "test/command_line_test.rb",
    "test/compass_test.rb",
    "test/configuration_test.rb",
    "test/fixtures/stylesheets/blueprint/config.rb",
    "test/fixtures/stylesheets/compass/config.rb",
    "test/fixtures/stylesheets/yui/config.rb",
    "test/sass_extensions_test.rb",
    "test/test_helper.rb",
    "examples/blueprint_default/config.rb",
    "examples/blueprint_plugins/config.rb",
    "examples/blueprint_semantic/config.rb",
    "examples/compass/config.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
