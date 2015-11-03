The end goal of chef is to manage your nodes.

Chef client: Its job is to keep your nodes in-lined with its desired state. Chef client knows what is the desired state of the node by asking the chef server.

<h2>Getting started</h2>

<h3>Install chef development kit</h3>

1. Install the latest chef development kit from here. https://downloads.chef.io/chef-dk/

2. Test the installtion by verifying the chef development kit version using the following command.

<code language="ruby">
<pre>chef --version
</pre>
</code>

Other than chef, there are number of tools which get installed as the part if development kit. The output shows the versions of each one of those.

<code language="ruby">
<pre>vagrant@mike:/vagrant/chef-repo/.chef$ chef --version
Chef Development Kit Version: 0.8.1
chef-client version: 12.4.4
berks version: 3.3.0
kitchen version: 1.4.2
vagrant@mike:/vagrant/chef-repo/.chef$
</pre>
</code>

<h3>Create a Repo</h3>

1. Create a repo to store the cookbooks, data bags and other chef related folders using the chef generate command.

<code language="ruby">
<pre>chef generate repo chef-repo
</pre>
</code>

chef-repo is the custom name given by the user and the name is relatively insignificant but it should be meaningful to you.

Once you execute the above command, as a net result you will see a bunch of folders and files created inside the chef-repo folder.

<h3>Test Driven Workflow</h3>

In this guide we will look in to a test driven workflow where in we will have a web server which says hello world when we pull up the web page.

First create a cookbook using the chef generate command. The name of the cookbook is arbitrary and it should mean something to you. In this example, we are going to call our cookbook "webserver".

Note: Make sure you execute the command from the /chef-repo/cookbooks directory to create the cookbook in the cookbooks directory.

<code language="ruby">
<pre>chef generate cookbook webserver
</pre>
</code>

Now, we have a cookbook named webserver and now we will start with the integration test. In order to run this integration test, you need a environment to run out webserver recipe.

So, when it comes to environment, one of the things that you can do is, you can use a tool called testkitchen. It allows you to spin up virtual machines where you can execute your recipes. One of the best ways you can use test kitchen is to use vagrant. If you do not have any idea about vagrant, you could use something like AWS ec2 or digital ocean to spin up virtual machines. In this example, we will stick with vagrant.

The environment details can set setup in our webserver cookbooks kitchen.yml file. If you open the webserver cookbook in sublime or any other text editor, you will find the kitchen.yml file in the webserver folder. 

The kitchen.yml file for our testing looks like the following.

<code language="ruby">
<pre>---
driver:
  name: vagrant

provisioner:
  name: chef_zero

platforms:
  - name: ubuntu-14.04
 # - name: centos-7.1

suites:
  - name: default
    run_list:
      - recipe[webserver::default]
    attributes:
</code>

As you can  see, i have commented out centos-7.1 under platforms because, we are going to test this only on ubuntu.

Execute the following kitchen command to list out all our default environment setup.

<code language="ruby">
<pre>kitchen list
</pre>
</code>

Example output:

<code language="ruby">
<pre>Instance             Driver   Provisioner  Verifier  Transport  Last Action
default-ubuntu-1404  Vagrant  ChefZero     Busser    Ssh        <Not Created>
</pre>
</code>

To launch the vm for our cookbook testing, just execute the following command. It will launch all the VM's mentioned in the kitchen.yml file. In our case its just ubuntu. But you can mention as many platforms you want.

<code language="ruby">
<pre>kitchen create
</pre>
</code>

So the above one command could launch as many VM's you want based on the kitchen configuration. One the Vm is created , you can run "kitchen list" comand to check the created status.

It will take a while to lauch the test vagrant VM. Once launched, you will have your test VM ready for integration testing.

<h3>Writing Integration Tests</h3>

When we generated the cookbook using chefdk, it automaticlly create alll the necessary test files. You can see a test folder will the following tree structure.

<code language="ruby">
<pre>└── test
    └── integration
        ├── default
        │   └── serverspec
        │       └── default_spec.rb
        └── helpers
            └── serverspec
                └── spec_helper.rb
</pre>
</code>

We will write all the tests in serverspec. Serverspec is build on top of ruby test framework rspec.

If you open default_spec.rb file, you will see the default skeleton for our web server cookbook. Explaining serverpsec is out of scope of this article. Visit http://serverspec.org/resource_types.html for more deatils on server spec.

So our first test case is to test if the webserver is present in the server or not. The test block looks like the following.

<pre>
<code language="ruby">require 'spec_helper'

describe 'webserver::default' do

  it 'displays the home page' do
    expect(command("wget http://localhost").exit_status).to eq 0
  end
end
</code>
</pre>

Basically, the above code runs the curl command to localhost and equates the exit status to 0. If the exit status is 0, web server is present in the server. 

This test should fail for us, because, we haven't configured the web server yet.

Lets try running this failing test using test kitchen.

Execute the following command from webserver cookbook directory to set up chef-client and run our webserver cookbook on our test kitchen node we created earlier.

<pre>
<code language="ruby">kitchen converge
</code>
</pre>

The above command will return a successfull chef client run because our webserver cookbook dont have any resources as of now.

Now, lets run our failing test using the following command. It will install all the necessary server spec gem to run the tests.

<pre>
<code language="ruby">kitchen verify
</code>
</pre>




















