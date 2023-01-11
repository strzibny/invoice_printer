# Script to regenerate all examples
examples_directory = File.expand_path('../examples', __FILE__)
@examples = Dir.glob("#{examples_directory}/*.rb")

@examples.each do |example|
  puts "Running #{example}"
  Dir.chdir(examples_directory) do
    `ruby #{example}`
  end
end