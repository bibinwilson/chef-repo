require 'spec_helper'

describe 'webserver::default' do

  it 'displays the home page' do
    expect(command("wget http://localhost").exit_status).to eq 0
  end
  
  it "it installs apache" do
    expect(package apache2).to be_installed
  end

end


