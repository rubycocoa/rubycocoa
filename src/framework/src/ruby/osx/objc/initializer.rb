require 'osx/cocoa'
require 'pathname'

begin
  lib_path = ENV['DYLD_LIBRARY_PATH']
  unless lib_path.nil?
    env = lib_path.split('/').last.downcase
    if %(debug release).include?(env)
      RUBYCOCOA_ENV = env
    else
      RUBYCOCOA_ENV = 'debug'
    end
  else
    RUBYCOCOA_ENV = 'release'
  end
rescue
  RUBYCOCOA_ENV = 'release'
end

# ActiveRecord uses RAILS_ENV internally to figure out which environment key to parse in 
# database.yml.  Since we use the non-standard release and debug environments, we need to 
# set this here
RAILS_ENV = RUBYCOCOA_ENV

RUBYCOCOA_ROOT = 
  if RUBYCOCOA_ENV == 'debug'
    Pathname.new(ENV['DYLD_LIBRARY_PATH'] + "../../../").cleanpath
  else
    Pathname.new(OSX::NSBundle.mainBundle.bundlePath.fileSystemRepresentation)
  end

$:.unshift(RUBYCOCOA_ROOT)


# Environment initialization scheme ported/derived from Rails' Initializer.
require 'erb'
module OSX
  # Rails-like Initializer responsible for processing configuration.
  class Initializer
    # The Configuration instance used by this Initializer instance.
    attr_reader :configuration
    
    # Run the initializer.  The #process method is run by default which 
    # runs all the initialization routines.  You can alternatively specify 
    # a command to run.
    # 
    #    OSX::Initializer.run(:set_load_path)
    #
    def self.run(command = :process, configuration = Configuration.new)
      yield configuration if block_given?
      initializer = new configuration
      initializer.send(command)
      initializer
    end
    
    # Create an initializer instance that references the given 
    # Configuration instance. 
    def initialize(configuration)
      @configuration = configuration
    end
    
    # Step through the initialization routines, skipping the active_record 
    # routines if active_record isnt' being used.
    def process
      set_load_path
      copy_load_paths_for_release
      require_frameworks
      load_environment
      
      if configuration.use_active_record?
        initialize_database_directories
        initialize_database
        initialize_active_record_settings
      end
    end
    
    # Requires all frameworks specified by the Configuration#objc_frameworks
    # list.  This is also responsible for including osx/active_record_proxy if 
    # use_active_record? is true
    def require_frameworks
      configuration.objc_frameworks.each { |framework| OSX.require_framework(framework) }
      if configuration.use_active_record?
        require 'active_support'
        configuration.active_record = OrderedOptions.new
        require 'active_record'        
        require Pathname.new(File.dirname(__FILE__) + "/../active_record_proxy").cleanpath
      end
    end
    
    def initialize_database_directories
      return if configuration.environment == 'debug'
      
      app_name = OSX::NSBundle.mainBundle.bundleIdentifier.to_s.scan(/\w+$/).first
      user_app_support_path = File.join(OSX::NSSearchPathForDirectoriesInDomains(OSX::NSLibraryDirectory, OSX::NSUserDomainMask, true)[0].to_s, "Application Support")
      app_support_path = File.join(user_app_support_path, app_name)
      
      `mkdir -p '#{app_support_path}'` unless File.exists?(app_support_path)
    end
    
    def initialize_database
      ActiveRecord::Base.configurations = configuration.database_configuration
      ActiveRecord::Base.logger = Logger.new($stderr)
      ActiveRecord::Base.colorize_logging = false
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.initialize_schema_information
    end
    
    # Initializes active_record settings. The available settings map to the accessors
    # of the  ActiveRecord::Base class.
    def initialize_active_record_settings
      configuration.send('active_record').each do |setting, value|
        ActiveRecord::Base.send("#{setting}=", value)
      end
    end

    def load_application_initializers
      Dir["#{configuration.root_path}/config/initializers/**/*.rb"].sort.each do |initializer|
        load(initializer)
      end
    end
    
    # Loads the environment specified by Configuration#environment_path, which
    # can be debug or release
    def load_environment
      return if @environment_loaded
      @environment_loaded = true
      
      config = configuration
      constants = self.class.constants
      eval(IO.read(configuration.environment_path), binding, configuration.environment_path)

      (self.class.constants - constants).each do |const|
        Object.const_set(const, self.class.const_get(const))
      end
    end
    
    # Set the paths from which your application will automatically load source files.
    def set_load_path
      load_paths = configuration.load_paths
      load_paths.reverse_each { |dir| $LOAD_PATH.unshift(dir) if File.directory?(dir) }
      $LOAD_PATH.uniq!
    end
    
    # Copy the default load paths to the resource directory for the application if 
    # we are building a release, otherwise we do nothing. When in debug mode, the 
    # files are loaded directly from your working directory.
    def copy_load_paths_for_release
      return if configuration.environment == 'debug'
      configuration.load_paths.each do |path|
        `cp -R #{RUBYCOCOA_ROOT}/#{path}` if File.directory?(path)
      end
    end
  end
  
  class Configuration
    # The applications base directory
    attr_reader :root_path
    
    # List of Objective-C frameworks that should be required
    attr_accessor :objc_frameworks
    
    #Stub for setting options on ActiveRecord::Base
    attr_accessor :active_record
    
    # Should the active_record framework be loaded. 
    attr_accessor :use_active_record
    
    # An array of additional paths to prepend to the load path. By default,
    # all +models+, +config+, +controllers+ and +db+ and mock paths are included in this list.
    attr_accessor :load_paths
    
    # The path to the database configuration file to use. (Defaults to
    # <tt>config/database.yml</tt>.)
    attr_accessor :database_configuration_file
    
    def initialize
      set_root_path!
      
      self.objc_frameworks              = []
      self.load_paths                   = default_load_paths
      self.database_configuration_file  = default_database_configuration_file
    end
    
    def set_root_path!
      @root_path = Pathname.new(::RUBYCOCOA_ROOT).realpath.to_s
    end
    
    # Returns the value of @use_active_record
    def use_active_record?
      @use_active_record
    end
    
    # Returns the value of RUBYCOCOA_ENV
    def environment
      ::RUBYCOCOA_ENV
    end
    
    # The path to the current environment's file (development.rb, etc.). By
    # default the file is at <tt>config/environments/#{environment}.rb</tt>.
    def environment_path
      "#{root_path}/config/environments/#{environment}.rb"
    end
    
    # Loads and returns the contents of the #database_configuration_file. The
    # contents of the file are processed via ERB before being sent through
    # YAML::load.
    def database_configuration
      YAML::load(ERB.new(IO.read(database_configuration_file)).result)
    end
    
    private
      def default_load_paths
        paths = %w(
          models
          controllers
          db
        ).map { |dir| "#{root_path}/#{dir}" }.select { |dir| File.directory?(dir) }
      end
      
      def default_database_configuration_file
        File.join(root_path, 'config', 'database.yml')
      end
  end
end
