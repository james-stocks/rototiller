require 'spec_helper'

module Rototiller
  module Task

    describe EnvVar do

      @count = 0
      ['with_default', 'without_default'].each do |method_signature|

        context method_signature do

          ['ENV set', 'ENV not set'].each do |env_set|

            context env_set do

              let (:message_header) { 'The environment variable:' }

              before(:each) do
                @var_name      = "VARNAME_#{(0...8).map { (65 + rand(26)).chr }.join}"
                @var_message   = "This is how you use #{@var_name}"
                @var_env_value = "VARENVVALUE_#{(0...8).map { (65 + rand(26)).chr }.join}"
                @var_default   = method_signature == 'with_default' ? "VARDEFAULT_#{(0...8).map { (65 + rand(26)).chr }.join}" : nil
                ENV[@var_name] = @var_env_value if env_set == 'ENV set'

                #args = [var_name, var_message]
                args = {:name => @var_name, :message => @var_message}

                #args.insert(1, var_default) if method_signature == 'with_default'
                args[:default] = @var_default if method_signature == 'with_default'
                @env_var = described_class.new(args)

                @expected_var_default = @var_default
                @expected_var_default = nil if method_signature == 'without_default'

                # validation
                if (method_signature == 'with_default' && env_set == 'ENV not set')
                  @formatted_message = "\e[33mINFO: #{message_header} '#{@var_name}' is not set. Proceeding with default value: '#{@var_default}': #{@var_message}\e[0m"
                  @expected_stop = nil
                elsif (method_signature == 'without_default' && env_set == 'ENV not set')
                  @formatted_message = "\e[31mERROR: #{message_header} '#{@var_name}' is required: #{@var_message}\e[0m"
                  @expected_stop = true
                  #elsif (method_signature == 'without_default' && env_set == 'ENV set')
                elsif (env_set == 'ENV set')
                  @formatted_message = "\e[32mINFO: #{message_header} '#{@var_name}' was found with value: '#{@var_env_value}': #{@var_message}\e[0m"
                  @expected_stop = nil
                end


              end

              describe '.var' do

                it 'returns the var' do
                  expect(@env_var.name).to eq(@var_name)
                end
              end

              describe '#set_env' do
                #FIXME: we really need tests on this, remove some from rototiller_task_spec
              end

              describe '.message' do

                #it 'returns the formatted message' do
                  #pending('FIXME: figure out if env should always be set')
                  #expect(@env_var.message).to eq(@formatted_message)
                #end
              end

              describe '.default' do

                it 'returns the default value' do
                  expect(@env_var.default).to eq(@expected_var_default)
                end
              end

              describe '.stop' do

                it 'knows if it should stop' do
                  expect(@env_var.stop).to eq(@expected_stop)
                end
              end
            end
          end
        end
      end

      it 'errors when no name is provided' do
        no_name = {:default => 'default value', :message => 'This is the message'}
        expect{described_class.new(no_name)}.to raise_error(ArgumentError, 'A name must be supplied to add_env')
      end
    end

  end
end
