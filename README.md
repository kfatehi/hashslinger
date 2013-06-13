# Hashslinger

ruby to shellscript DSL project inspired by not wanting to learn Chef nor Puppet, nor use bash directly

## Installation

Add this line to your application's Gemfile:

    gem 'hashslinger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hashslinger

## Usage

Call it from your Vagrantfile.
Oh, you can't use gems from a Vagrantfile. I'll need to turn it into a vagrant plugin.

I don't think I'll finish this... but my idea was basically to be able to put this into the Vagrantfile:

```ruby
  config.vm.provision :hashslinger, on_first_up:{ echo: %{
    Your dev environment is almost ready. What remains:
      1) Execute 'vagrant ssh' to enter the virtual machine.
      2) Execute '/vagrant/deployment/bootstrap.sh' in the VM to prepare the rails app.
  }}
```

And have that use Hashslinger's OnFirstUp class to generate a script with a "first up" if statement, basically producing this bash code and acting like a :shell provisioner.

```ruby
  config.vm.provision :shell, inline:<<-SHELL
    if [ ! -f /.first_up ]; then date > /.first_up
      echo "  Your dev environment is almost ready. What remains:"
      echo "    1) Execute 'vagrant ssh' to enter the virtual machine."
      echo "    2) Execute '/vagrant/deployment/bootstrap.sh' in the VM to prepare the rails app."
    fi
  SHELL
```

Anyway I got stuck getting vagrant to detect my plugin correctly and stopped caring because the use case was so simple.
Instead I've just put my bash code in manually!

The plugin system has made itself known to me right now as annoying -- hopefully it will become easier to hack on in future.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
