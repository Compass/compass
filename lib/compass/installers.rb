module Compass
  module Installers

    class InstallationError < Compass::Error
    end

    class DirectoryExistsError < InstallationError
    end

  end
end

require File.join(File.dirname(__FILE__), 'installers', 'manifest')
require File.join(File.dirname(__FILE__), 'installers', 'base')
require File.join(File.dirname(__FILE__), 'installers', 'stand_alone')
require File.join(File.dirname(__FILE__), 'installers', 'rails')

