require 'java'

Dir.glob("*.jar").each do |jar|
  require jar
end

source = "Hello {{name}}"
factory = com.github.mustachejava.DefaultMustacheFactory.new
template = factory.compile java.io.StringReader.new(source), 'example-template'

# Using standard StringWriter

writer = java.io.StringWriter.new
puts "Using #{writer.class.name}: "
template.execute(writer, {'name' => 'Dan'})
puts writer.to_s
puts

# Implementing a new Writer subclass

class RubyWriter < java.io.Writer
  java_signature 'void write(char[], int, int)'
  def write(chars, offset, length)
    stream << chars.slice(offset, length)
  end

  def to_s
    stream.join
  end

  private

  def stream
    @stream ||= []
  end
end

writer = RubyWriter.new
puts "Using #{writer.class.name}: "
template.execute(writer, {'name' => 'Dan'})
puts writer.to_s
puts
