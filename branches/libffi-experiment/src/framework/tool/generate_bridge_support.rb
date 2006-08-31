require `uname -r`.to_f >= 6.0 ? 'och_analyzer3.rb' : 'och_analyzer.rb'
require 'rexml/document'
require 'dl/import'
require 'dl/struct'

=begin
class OCHeaderAnalyzer
    def xml_elements
        elements = []
        constants.each do |const|
            element = REXML::Element.new('constant')
            element.add_attribute('name', const.name)
            element.add_attribute('type', const.rettype)
            elements << element
        end
        enums.each do |enum|
            element = REXML::Element.new('enum')
            element.add_attribute('name', enum)
            elements << element
        end
        functions.each do |func|
            element = REXML::Element.new('function')
            element.add_attribute('name', func.name)
            element.add_attribute('arguments_count', func.argc)
            func.args.each { |a| element.add_element('argument').text = a.rettype }
            element.add_element('return').text = func.rettype
            elements << element
        end
        typedefs.each do |original, _alias|
            element = REXML::Element.new('typedef')
            element.add_attribute('original', original)
            element.add_attribute('alias', _alias)
            elements << element
        end
        elements
    end
end
=end

class BridgeSupportGenerator
    def initialize(args)
        @headers = []
        @objc = false
        @out_io = STDOUT
        parse_args(args)
        scan_headers
        generate_xml
    end

    #######
    private
    #######

    # We can't really use RubyCocoa at this point to call the ObjC
    # runtime, because foundation methods like NSClassFromString are
    # not available yet because Foundation's bridge support file has
    # not been generated yet. So let's directly load the objc library
    # and call objc_getClass by ourself. 
    module OBJC
        extend DL::Importable

        dlload "libobjc.dylib"
        extern "void * objc_getClass(char *)"

        def self.is_objc_class?(name)
            objc_getClass(name) != nil
        end
    end

    def resolve_typedef(type)
        x = @resolved_typedef[type]
        return x unless x.nil?
       
         
    end

    def octype_of(varinfo)
        # detect ObjC classes
        if @objc 
            ary = varinfo.stripped_rettype.split(/\s/)
            if ary.length == 2 and ary.last == '*' and OBJC.is_objc_class?(ary.first)
                return :_C_ID
            end
        end

=begin
        real_type = resolve_typedef(varinfo.stripped_rettype)

        # resolve typedefs
        hash = @typedefs
        type = varinfo.stripped_rettype
        loop do
            new_type = hash[type]
        end

        # detect boxed types -> TODO

=end
        return varinfo.octype
    end

    def generate_xml
        document = REXML::Document.new
        document << REXML::XMLDecl.new
        root = document.add_element('signatures')
        @constants.each do |constant| 
            element = root.add_element('constant')
            element.add_attribute('name', constant.name)
            element.add_attribute('type', octype_of(constant))
        end
        @enums.each { |enum| root.add_element('enum').add_attribute('name', enum) }
        @functions.each do |function|
            element = root.add_element('function')
            element.add_attribute('name', function.name)
            element.add_attribute('argc', function.argc)
            element.add_attribute('variadic', true) if function.variadic?
            function.args.each do |arg|
                element.add_element('arg').add_attribute('type', octype_of(arg))
            end
            element.add_element('return').add_attribute('type', octype_of(function))
        end
        document.write(@out_io, 0)
    end

    def scan_headers
        @functions, @constants, @enums = [], [], []
        @typedefs = {}
        @headers.each do |path|
            analyzer = OCHeaderAnalyzer.new(path)
            @functions.concat(analyzer.functions)
            @typedefs.merge(analyzer.typedefs) do |key, old, new|
                STDERR.puts "typedef '#{key}' already defined -- skipping..."
                old
            end
            @constants.concat(analyzer.constants)
            @enums.concat(analyzer.enums)
        end
        @resolved_typedefs = {}
    end
 
    def parse_args(args)
        usage if args.empty?
        case args.first
            when '-f'
                usage if args.length != 2
                handle_framework(args[1])
                @objc = true 

            when '-h'
                usage if args.length < 2
                @headers.concat(args[1..-1])
            
            else
                usage 
        end
    end
   
    def handle_framework(val)
        path = framework_path(val)                
        die "Can't find framework '#{val}'" if path.nil?
        name = path.scan(/(\w+)\.framework$/)[0][0]
        headers = File.join(path, 'Headers')
        die "Can't locate framework headers at '#{headers}'" unless File.exists?(headers)
        @headers.concat(Dir.glob(File.join(headers, '**', '*.h')))
        libpath = File.join(path, name)
        die "Can't locate framework library at '#{libpath}'" unless File.exists?(libpath)
        OBJC.dlload(libpath)
    end
 
    def framework_path(val)
        return val if File.exists?(val)
        val += '.framework' unless /\.framework$/.match(val)
        ['/System/Library/Frameworks',
         '/Library/Frameworks',
         File.join(ENV['USER']), 'Library', 'Frameworks'].each do |dir|

            path = File.join(dir, val)
            return path if File.exists?(path)
        end
        return nil
    end

    def usage
        die "Usage: #{__FILE__} [-f <framework> | -h <headers...]>"
    end

    def die(msg)
        STDERR.puts msg
        exit 1
    end
end

BridgeSupportGenerator.new(ARGV)
