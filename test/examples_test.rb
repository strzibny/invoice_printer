require 'test_helper'

# Integration tests running the examples from /examples directory
class ExamplesTest < Minitest::Test
  def setup
    examples_directory = File.expand_path('../../examples', __FILE__)
    assets_directory = File.expand_path('../../assets', __FILE__)
    @examples = Dir.glob("#{examples_directory}/*.rb")
    @test_dir = File.absolute_path('./tmp/invoice_printer_examples')
    FileUtils.mkdir_p @test_dir
    FileUtils.copy_entry examples_directory, @test_dir
    FileUtils.cp_r assets_directory, File.absolute_path('./tmp/')
  end

  def teardown
    FileUtils.rm_rf @test_dir if File.exist?(@test_dir)
  end

  # 1, copy example to the test directory
  # 2, run the example
  # 3, compare the output with example from /examples
  def test_examples
    @examples.each do |example|
      example_file = File.join(@test_dir, File.basename(example))
      original_pdf = example.gsub('.rb', '.pdf')
      original_a4_pdf = example.gsub('.rb', '_a4.pdf')
      result_pdf = example_file.gsub('.rb', '.pdf')
      result_a4_pdf = example_file.gsub('.rb', '_a4.pdf')

      Dir.chdir(@test_dir) do
        `ruby -I../../lib #{example_file}`

        similarity = (File.read(original_pdf) == File.read(result_pdf))
        assert_equal true, similarity, "#{original_pdf} does not match #{result_pdf}"

        similarity = (File.read(original_a4_pdf) == File.read(result_a4_pdf))
        assert_equal true, similarity, "#{original_a4_pdf} does not match #{result_a4_pdf}"
      end
    end
  end
end
