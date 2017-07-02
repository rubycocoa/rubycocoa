require 'rake'
require 'rake/tasklib'

module HeaderDoc
  class HeaderDocTask < Rake::TaskLib

    attr_accessor :name
    attr_accessor :headerdoc_cmd, :gatherhd_cmd
    attr_accessor :files, :output_dir, :toppage
    def initialize(name = :headerdoc)
      @name = name
      @headerdoc_cmd = `xcrun -f headerdoc2html`.chomp
      @gatherhd_cmd = `xcrun -f gatherheaderdoc`.chomp
      @files = []
      @output_dir = 'doc'
      @toppage = 'index.html'

      yield self if block_given?

      define
    end

    protected

    def define
      desc "Generate HeaderDoc Documentation" unless Rake.application.last_description
      task(self.name) do
        sh([@headerdoc_cmd, '-o', @output_dir, @files].flatten.join(" "))
        sh(@gatherhd_cmd, @output_dir, @toppage)
      end
    end
  end
end
