require "press/printer"

module Press

  def self.print(*data, &blk)
    Printer.print *data, &blk
  end

  def self.printfm(file, m, *data, &blk)
    Printer.printfm file, m, *data, &blk
  end

  def self.printe(e, *data)
    Printer.printe e, *data
  end

  def self.printfme(file, m, e, *data)
    Printer.printfme file, m, e, *data
  end
end
