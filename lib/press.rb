require "press/printer"

module Press

  def print(*data, &blk)
    Printer.print *data, &blk
  end

  def printfm(file, m, *data, &blk)
    Printer.printfm file, m, *data, &blk
  end

  def printe(e, *data)
    Printer.printe e, *data
  end

  def printfme(file, m, e, *data)
    Printer.printfme file, m, e, *data
  end
end
