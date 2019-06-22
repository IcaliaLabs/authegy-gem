require 'authegy'
require 'fileutils'

def run_generator(generator_name)
    system "rails g #{generator_name}"
end