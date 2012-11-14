require "press/printer"

module Press

  def ctx(data)
    Printer.ctx = data
  end

  def mtx(tag)
    Printer.mtx = tag
  end

  def pd(*data, &blk)
    Printer.pd *data, &blk
  end

  def mpd(*data, &blk)
    Printer.mpd *data, &blk
  end

  def pdfm(file, m, *data, &blk)
    Printer.pdfm file, m, *data, &blk
  end

  def mpdfm(file, m, *data, &blk)
    Printer.mpdfm file, m, *data, &blk
  end

  def pde(e, *data)
    Printer.pde e, *data
  end

  def mpde(e, *data)
    Printer.mpde e, *data
  end

  def pdfme(file, m, e, *data)
    Printer.pdfme file, m, e, *data
  end

  def mpdfme(file, m, e, *data)
    Printer.mpdfme file, m, e, *data
  end

  class Logger

    def self.level(*attrs)
      attrs.each do |attr|
        class_eval "def #{attr} args; Printer.pd :type => @type, :level => '#{attr}', :message => args end", __FILE__, __LINE__
      end
    end

    level :debug, :info, :warn, :error, :fatal

    def initialize(type)
      @type = type
    end
  end
end
