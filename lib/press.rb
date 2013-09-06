require "press/printer"

module Press

  # context
  def ctx(data)
    Printer.ctx = data
  end

  # measure tag
  def mtx(tag)
    Printer.mtx = tag
  end

  # measure tag, context
  def mctx(tag, data)
    mtx tag
    ctx data
  end

  # print data
  def pd(*data, &blk)
    Printer.pd *data, &blk
  end

  # measure print data
  def mpd(*data, &blk)
    Printer.mpd *data, &blk
  end

  # measure print data
  def xpd(*data, &blk)
    Printer.xpd *data, &blk
  end

  # sample print data
  def spd(*data)
    Printer.spd *data
  end

  # count print data
  def cpd(*data)
    Printer.cpd *data
  end

  # print data file method
  def pdfm(file, m, *data, &blk)
    Printer.pdfm file, m, *data, &blk
  end

  # measure print data file method
  def mpdfm(file, m, *data, &blk)
    Printer.mpdfm file, m, *data, &blk
  end

  # measure print data file method
  def xpdfm(file, m, *data, &blk)
    Printer.xpdfm file, m, *data, &blk
  end

  # sample print data file method
  def spdfm(file, m, *data)
    Printer.spdfm file, m, *data
  end

  # count print data file method
  def cpdfm(file, m, *data)
    Printer.cpdfm file, m, *data
  end

  # print data exception
  def pde(e, *data)
    Printer.pde e, *data
  end

  # measure print data exception
  def mpde(e, *data)
    Printer.mpde e, *data
  end

  # count print data exception
  def cpde(e, *data)
    Printer.cpde e, *data
  end

  # print data file method exception
  def pdfme(file, m, e, *data)
    Printer.pdfme file, m, e, *data
  end

  # measure print data file method exception
  def mpdfme(file, m, e, *data)
    Printer.mpdfme file, m, e, *data
  end

  # count print data file method exception
  def cpdfme(file, m, e, *data)
    Printer.cpdfme file, m, e, *data
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
