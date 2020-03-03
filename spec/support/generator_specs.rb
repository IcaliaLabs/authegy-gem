require 'fileutils'

RSpec::Matchers.define :have_migration do |migration_name|
  match do
    migrations_directory = Pathname.new(Dir.pwd).join('db', 'migrate')
    pattrn = /\A#{migrations_directory}\/(\d+)_#{migration_name}.rb\z/
    Dir[migrations_directory.join('**', '*')]
      .select { |entry| entry =~ pattrn }
      .any?
  end
end

module GeneratorSpecMethods
  def run_generator(generator_name)
    system "rails g #{generator_name} > /dev/null"
  end

  def gem_root
    Pathname.new File.expand_path "#{Rails.root}/../.."
  end

  def setup_example_app_context(example_app_dir_name)
    example_app_source_path = gem_root.join 'spec',
                                            'fixtures',
                                            example_app_dir_name
    
    example_app_path = gem_root.join 'tmp', example_app_dir_name

    FileUtils.cp_r example_app_source_path, example_app_path
    Dir.chdir example_app_path
  end

  def teardown_example_app_context(example_app_dir_name)
    Dir.chdir gem_root
    FileUtils.rm_rf gem_root.join 'tmp', example_app_dir_name
  end

  def migration_contents(migration_name)
    migrations_directory = Pathname.new(Dir.pwd).join('db', 'migrate')
    pattrn = /\A#{migrations_directory}\/(\d+)_#{migration_name}.rb\z/
    migration = Dir[migrations_directory.join('**', '*')]
                .select { |entry| entry =~ pattrn }
                .first
    raise "Migration not found: #{migration_name}" unless migration.present?
    File.read migration
  end
end

# Apply the generator spec methods into the generator specs:
RSpec.configure do |config|
  config.include GeneratorSpecMethods, type: :generator
end
