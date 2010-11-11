require 'rubygems'
require "pp"
begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError
  puts "could not load wirble. skipping..."
end

# Prompt behavior
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

# Autocomplete
require 'irb/completion'

# History
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 500
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# print SQL to STDOUT
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

# Easily print methods local to an object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# load a user for the 
def some_user(user_id=1)
 @user = User.find(user_id, :rid => "internal")
end