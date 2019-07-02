require 'fileutils'

module GeneratorSpecMethods
  def run_generator(generator_name)
    system "rails g #{generator_name} > /dev/null"
  end

  def migration_file
    generated_migration_folder = File.expand_path('../tmp/db/migrate', __FILE__)
    
    Dir.entries(generated_migration_folder)
       .each { |entry| entry.scan(/\d/).join.to_i }
       .max
  end

  def render_erb_file(template)
    migration_version = '[5.2]'
    render = ERB.new(File.read(template))
    render.result(binding)
  end
end

# Apply the generator spec methods into the generator specs:
RSpec.configure do |config|
  config.include GeneratorSpecMethods, type: :generator
end
