# register .m .mm file to use CParser
require 'yard'
YARD::Parser::SourceParser.register_parser_type(:objc, YARD::Parser::C::CParser, %w(m mm))
YARD::Handlers::Processor.register_handler_namespace(:objc, YARD::Handlers::C)
