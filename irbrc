require 'rubygems'
require "pp"


def save_require(name)
  require name
  yield
rescue LoadError
  puts "could not load #{name}. skipping..."
end


save_require("wirble") do
  Wirble.init
  Wirble.colorize
end

save_require("json") do
  def json_pp(json)
    puts JSON.pretty_generate(JSON.parse(json))
  end
end

# Prompt behavior
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

# Autocomplete
require 'irb/completion'

# History
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 500
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Easily print methods local to an object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# Prompts
IRB.conf[:PROMPT][:CUSTOM] = {
    :PROMPT_N => ">> ",
    :PROMPT_I => ">> ",
    :PROMPT_S => nil,
    :PROMPT_C => " > ",
    :RETURN => "=> %s\n"
}

# Set default prompt
IRB.conf[:PROMPT_MODE] = :CUSTOM


# Simple ri integration
def ri(*names)
  system("ri #{names.map {|name| name.to_s}.join(" ")}")
end
