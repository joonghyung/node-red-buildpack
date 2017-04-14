$: << 'cf_spec'
require 'bundler/setup'
require 'json'
require 'fileutils'
require 'tmpdir'
require 'open3'

describe "Appdynamics Installer" do
  let(:buildpack_dir)           { File.join(File.expand_path(File.dirname(__FILE__)), '..', '..') }
  let(:build_dir)               { Dir.mktmpdir }
  let(:app_name)                { 'unit-test-app' }
  let(:profile_d_appdynamics)   { File.join(build_dir, '.profile.d', 'appdynamics-setup.sh') }
  let(:old_bp_dir)              { ENV['BP_DIR'] }
  let(:old_vcap_application)    { ENV['VCAP_APPLICATION'] }
  let(:old_vcap_services)       { ENV['VCAP_SERVICES'] }
  let(:old_host_name)           { ENV['appdynamics_controller_host_name'] }
  let(:old_port)                { ENV['appdynamics_controller_port'] }
  let(:old_account)             { ENV['appdynamics_agent_account_name'] }
  let(:old_ssl)                 { ENV['appdynamics_controller_ssl_enabled'] }
  let(:old_key)                 { ENV['appdynamics_agent_account_access_key'] }
  let(:old_app)                 { ENV['appdynamics_agent_application_name'] }
  let(:old_tier)                { ENV['appdynamics_agent_tier_name'] }
  let(:old_prefix)              { ENV['appdynamics_agent_node_name_prefix'] }

  before do
    ENV["BP_DIR"] = buildpack_dir
      vcap_application =  {
        "application_name"=> app_name
      }

    ENV['VCAP_APPLICATION'] = vcap_application.to_json
  end

  after do
    FileUtils.rm_rf(build_dir) if defined? build_dir
    ENV['BP_DIR'] = old_bp_dir
    ENV['vcap_application'] = old_vcap_application
    ENV['vcap_services'] = old_vcap_services
    ENV['appdynamics_controller_host_name'] = old_host_name
    ENV['appdynamics_controller_port'] = old_port
    ENV['appdynamics_agent_account_name'] = old_account
    ENV['appdynamics_controller_ssl_enabled'] = old_ssl
    ENV['appdynamics_agent_account_access_key'] = old_key
    ENV['appdynamics_agent_application_name'] = old_app
    ENV['appdynamics_agent_tier_name'] = old_tier
    ENV['appdynamics_agent_node_name_prefix'] = old_prefix
  end

  subject do
    vcap_services = "{\"elephantsql\":[{}],\"appdynamics\":[{\"credentials\":{\"host-name\":\"test-host\",\"port\":\"1234\",\"account-name\":\"test-account\",\"ssl-enabled\":\"true\",\"account-access-key\":\"test-key\"}}]}"
    Dir.chdir(buildpack_dir) do
      @stdout, @stderr, @status = Open3.capture3("VCAP_SERVICES=\"#{vcap_services} profile/appdynamics-setup.sh")
    end
  end

  # context 'vcap_services is not present in environment' do
  #   let(:vcap_services) { "{}" }

  #   it 'does not create .profile.d/appdynamics-setup.sh file' do
  #     subject
  #     expect(@status).to be_success
  #   end
  # end

  context 'vcap services contains appdynamics' do
    it "sets the appropriate environment variables from VCAP_SERVICES AppDynamocs credentials" do
      subject
      expect(@status).to be_success
      expect(ENV['APPDYNAMICS_CONTROLLER_HOST_NAME']).to equal('test-host-name')
      expect(ENV['APPDYNAMICS_CONTROLLER_PORT']).to equal('1234')
      expect(ENV['APPDYNAMICS_AGENT_ACCOUNT_NAME']).to equal('test-customer')
      expect(ENV['APPDYNAMICS_CONTROLLER_SSL_ENABLED']).to equal('true')
      expect(ENV['APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY']).to equal('appdynamics_license_key_set_by_service_binding')
      expect(ENV['APPDYNAMICS_AGENT_APPLICATION_NAME']).to equal('unit-test-app')
      expect(ENV['APPDYNAMICS_AGENT_TIER_NAME']).to equal('unit-test-app')
      expect(ENV['APPDYNAMICS_AGENT_NODE_NAME_PREFIX']).to equal('unit-test-app')
    end
  end
end
