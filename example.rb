$:.unshift(File.expand_path(File.join(Dir.getwd, "lib")))

require "press"

module Plain
  extend Press

  def self.run
    puts "########## running ##########"

    pd hello: "world"
    puts

    r = pd hello: "world" do
      42
    end
    puts r
    puts

    pdfm __FILE__, __method__, hello: "world"
    puts

    r = pdfm __FILE__, __method__, hello: "world" do
      42
    end
    puts r
    puts

    begin
      1 / 0
    rescue => e
      pde e, hello: "world"
      pdfme __FILE__, __method__, e, hello: "world"
    end
    puts
  end
end

module Measure
  extend Press

  def self.run
    puts "########## running ##########"

    mpd hello: "world"
    puts

    r = mpd hello: "world" do
      42
    end
    puts r
    puts

    mpdfm __FILE__, __method__, hello: "world"
    puts

    r = mpdfm __FILE__, __method__, hello: "world" do
      42
    end
    puts r
    puts

    begin
      1 / 0
    rescue => e
      mpde e, hello: "world"
      mpdfme __FILE__, __method__, e, hello: "world"
    end
    puts
  end
end

module MeasureEvent
  extend Press

  def self.run
    puts "########## running ##########"

    mpd hello: "world", event: "sunset"
    puts

    r = mpd hello: "world", event: "sunset" do
      42
    end
    puts r
    puts

    mpdfm __FILE__, __method__, hello: "world", event: "sunset"
    puts

    r = mpdfm __FILE__, __method__, hello: "world", event: "sunset" do
      42
    end
    puts r
    puts

    begin
      1 / 0
    rescue => e
      mpde e, hello: "world", event: "sunset"
      mpdfme __FILE__, __method__, e, hello: "world", event: "sunset"
    end
    puts
  end
end

Plain.mctx nil, nil
Plain.run
Plain.mctx nil, app: "slasher", deploy: "staging"
Plain.run

Measure.mctx nil, nil
Measure.run
Measure.mctx ["ripper", "production"].join("."), nil
Measure.run
Measure.mctx ["screamer", "testing"].join("."), app: "shreiker", deploy: "beta"
Measure.run

MeasureEvent.mctx nil, nil
MeasureEvent.run
MeasureEvent.mctx ["ripper", "production"].join("."), nil
MeasureEvent.run
MeasureEvent.mctx ["screamer", "testing"].join("."), app: "shreiker", deploy: "beta"
MeasureEvent.run
