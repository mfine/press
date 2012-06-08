require "time"

module Press
  module Printer

    def self.ctx
      @ctx ||= {}
    end

    def self.ctx=(data)
      @ctx = data
    end

    def self.pd(*data, &blk)
      write $stdout, hashify(*data, {}), &blk
    end

    def self.pdfm(file, m, *data, &blk)
      write $stdout, hashify(*data, file: File.basename(file, ".rb"), fn: m), &blk
    end

    def self.pde(e, *data)
      write $stderr, hashify(*data, at: "error", class: e.class, message: e.message)
    end

    def self.pdfme(file, m, e, *data)
      write $stderr, hashify(*data, at: "error", class: e.class, message: e.message, file: File.basename(file, ".rb"), fn: m)
    end

    def self.hashify(*data, initial)
      data.compact.reduce(initial.merge(ctx)) { |d, v| d.merge v }
    end

    def self.stringify(data)
      data.map do |(k, v)|
        case v
        when Hash
          "#{k}={.."
        when Array
          "#{k}=[.."
        when NilClass
          "#{k}=nil"
        when Float
          "#{k}=#{format("%.3f", v)}"
        when Time
          "#{k}=#{v.iso8601}"
        else
          v_str = v.to_s.strip
          v_str.match(/\s/) ? "#{k}=\"#{v_str}\"" : "#{k}=#{v_str}"
        end
      end.join(" ")
    end

    def self.write(file, data, &blk)
      unless blk
        file.puts stringify(data)
        file.flush
      else
        start = Time.now
        write file, { at: "start" }.merge(data)
        begin
          result = yield
        rescue => e
          pde e, data
          raise
        end
        write file, { at: "finish", elapsed: Time.now - start }.merge(data)
        result
      end
    end
  end
end
