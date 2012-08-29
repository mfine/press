require "press/printer"

module Press

  def ctx(data)
    Printer.ctx = data
  end

  def pd(*data, &blk)
    Printer.pd *data, &blk
  end

  def pdfm(file, m, *data, &blk)
    Printer.pdfm file, m, *data, &blk
  end

  def pde(e, *data)
    Printer.pde e, *data
  end

  def pdfme(file, m, e, *data)
    Printer.pdfme file, m, e, *data
  end
end

class PressLogger

  def self.level(*attrs)
    attrs.each do |attr|
      class_eval "def #{attr} args; Printer.pd type: @type, level: '#{attr}', message: args end", __FILE__, __LINE__
    end
  end

  level :debug, :info, :warn, :error, :fatal

  def initialize(type)
    @type = type
  end
end
