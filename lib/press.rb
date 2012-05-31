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
