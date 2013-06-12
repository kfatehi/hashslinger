require 'spec_helper'

describe Hashslinger do
  let (:vm) { double('vm', provision:lambda{|a,b|}) }
  let (:config) { double('config', vm:vm) }
  subject { Hashslinger.with_vagrant_config(config) }

  before { config.should_receive(:vm) }

  describe ".on_first_up" do
    describe "echo" do
      context 'multiline string' do
        let (:string) {"my \n  strin\"g  has m\'any  \n   lines and\n spaces plus tr!cky { cha\`ra@cte$rts"}
        it "configures vagrant with a shell script" do
          vm.should_receive(:provision).with(:shell, kind_of(Hash))
          subject.on_first_up echo: string
        end
      end
    end
  end
end