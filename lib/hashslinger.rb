require "hashslinger/version"
require 'tempfile'
require 'shellwords'

##
# Provides a DSL to provision a Vagrant VM
#  - config.vm.provision :shell, inline: OUTPUT
module Hashslinger
  module_function
  class ShellScript < Tempfile
    attr_accessor :builder
    def render
      builder.render
      rewind
      read
    end
  end

  class OnFirstUp
    attr_accessor :shell_script

    ##
    # Only runs once by writing/checking for filepath +@ran_flag+
    def initialize
      self.shell_script = ShellScript.new "Hashslinger-shellscript"
      self.shell_script.builder = self
      @line_cache = []
    end 
    
    def echo text
      text.split("\n").each do |line|
        line.split("\"")
        line = <<-SHELL
          echo "#{Shellwords.escape(line)}"
        SHELL
        @line_cache << line.strip
      end
    end

    def render
      self.shell_script.puts <<-SHELL
        if [ ! -f /.DidntLearnPuppetOrChef//OnFirstUp ]; then
          date > /.DidntLearnPuppetOrChef//OnFirstUp
          #{@line_cache.join("\n")}
        fi
      SHELL
    end
  end

  ##
  # Generates shell script that runs once
  # +does+ can set up the following
  # - echo: echo the text
  def self.on_first_up actions
    if defined? Vagrant
      ofu = OnFirstUp.new
      actions.each {|key, value| ofu.send(key, value)}
      if defined? RSpec
        puts "Printing shell script ..."
        puts ofu.shell_script.render
        puts "Done."
      end
      @vagrantconfig.vm.provision :shell, inline: ofu.shell_script.render    
    else
      puts "Hashslinger should be called from a Vagrantfile"
    end
  end

  def self.with_vagrant_config config
    raise "Not vagrant" unless config.respond_to? :vm
    @vagrantconfig = config
    self
  end
end
