require "vagrant"

module VagrantPlugins
  module Hashslinger
    class Plugin < Vagrant.plugin("2")
      name "hashslinger"
      description <<-DESC
      Provides support for provisioning your virtual machines with
      shell scripts through keyvanfatehi/hashslinger DSL
      DESC

      config(:hashslinger, :provisioner) do
        require File.expand_path("../config", __FILE__)
        Config
      end

      provisioner(:hashslinger) do
        require File.expand_path("../provisioner", __FILE__)
        Provisioner
      end
    end
  end
end
