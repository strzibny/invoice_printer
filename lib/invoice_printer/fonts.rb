require 'invoice_printer'

class InvoicePrinter::Fonts
  ASSETS_PATH = File.expand_path('../../../assets', __FILE__)

  def self.paths_for(font_name)
    send(font_name)
  rescue NoMethodError
    raise "Not supported font #{font_name}"
  end

  def self.opensans
    {
      :normal      => "#{ASSETS_PATH}/fonts/opensans/OpenSans-Regular.ttf",
      :italic      => "#{ASSETS_PATH}/fonts/opensans/OpenSans-Regular.ttf",
      :bold        => "#{ASSETS_PATH}/fonts/opensans/OpenSans-Regular.ttf",
      :bold_italic => "#{ASSETS_PATH}/fonts/opensans/OpenSans-Regular.ttf"
    }
  end

  def self.overpass
    {
      :normal      => "#{ASSETS_PATH}/fonts/overpass/Overpass-Regular.ttf",
      :italic      => "#{ASSETS_PATH}/fonts/overpass/Overpass-Regular.ttf",
      :bold        => "#{ASSETS_PATH}/fonts/overpass/Overpass-Regular.ttf",
      :bold_italic => "#{ASSETS_PATH}/fonts/overpass/Overpass-Regular.ttf"
    }
  end

  def self.roboto
    {
      :normal      => "#{ASSETS_PATH}/fonts/roboto/Roboto-Regular.ttf",
      :italic      => "#{ASSETS_PATH}/fonts/roboto/Roboto-Regular.ttf",
      :bold        => "#{ASSETS_PATH}/fonts/roboto/Roboto-Regular.ttf",
      :bold_italic => "#{ASSETS_PATH}/fonts/roboto/Roboto-Regular.ttf"
    }
  end
end