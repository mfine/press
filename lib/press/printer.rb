require "time"

module Press
  module Printer

    def self.print(*data, &blk)
      output format(*data), &blk
    end

    def self.printfm(file, m, *data, &blk)
      output formatfm(file, m, *data), &blk
    end

    def self.printe(e, *data)
      output e, format(*data)
    end

    def self.printfme(file, m, e, *data)
      output e, formatfm(file, m, *data)
    end

    def self.format(*data)
      data.compact
    end

    def self.formatfm(file, m, *data)
      format(*data).reduce(file: File.basename(file,"*.rb"), fn: m) { |d, v| d.merge(v) }
    end

    def self.stringify(data)
      data.map do |k, v|
        case v
        when Hash, Array
          "#{k}=..."
        when NilClass
          "#{k}=nil"
        when Float
          "#{k}=#{format("%.3f", v)}"
        when Time
          "#{k}=#{v.iso8601}"
        else
          v_str = v.to_s
          v_str.match(/\s/) ? "#{k}=\"#{v_str}\"" : "#{k}=#{v_str}"
        end
      end
    end

    def self.output(data, &blk)
      unless blk
        $stdout.puts stringify(data)
        $stdout.flush
      else
        start = Time.now
        output data.merge(at: "start")
        result = yield
        output data.merge(at: "finish", elapsed: Time.now - start)
        result
      end
    end

    def self.outpute(e, data)
      $stderr.puts stringify(data.merge(at: "exception", class: e.class, message: e.message))
      $stderr.flush
    end
  end
end
