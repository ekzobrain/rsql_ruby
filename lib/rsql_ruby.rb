require_relative 'rsql_ruby/parser'

# Main module
module RsqlRuby
  # Parse string to structures.
  def self.parse(str)
    parser = RsqlRuby::Parser.new
    parser.parse(str)
  end
end
