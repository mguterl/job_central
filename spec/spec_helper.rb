require 'rubygems'
require 'spec'
require 'fakeweb'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'job_central'

Spec::Runner.configure do |config|
  
end
