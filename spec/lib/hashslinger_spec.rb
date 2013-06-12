require 'spec_helper'

describe Hashslinger do
  describe ".on_first_up" do
    describe "echo" do
      context 'multiline string' do
        let (:string) {"my \n  strin\"g  has m\'any  \n   lines and\n spaces plus tr!cky { cha\`ra@cte$rts"}
        it "converts to shell script" do
          subject.on_first_up(echo: string).should be_a String
        end
      end
    end
  end

  describe "provisioning plugin usage" do
    let (:vm) { double('vm') }
    let (:config) { double('config', vm:vm) }

    before do
      vm.stub(:provision)
    end

    it "can be used as a vagrant plugin taking a hash argument" do
      vm.should_receive(:provision).with(:hashslinger, kind_of(Hash))
    end

    it "sends a shell script through" do

    end

    after do
      config.vm.provision :hashslinger, on_first_up:{ echo: %{
        Your dev environment is almost ready. What remains:
          1) Execute 'vagrant ssh' to enter the virtual machine.
          2) Execute '/vagrant/deployment/bootstrap.sh' in the VM to prepare the rails app.
      }}
    end
  end
end