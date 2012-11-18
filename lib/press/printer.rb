require "time"

module Press
  module Printer

    def self.ctx=(data)
      @ctx = data
    end

    def self.mtx=(tag)
      @mtx = tag
    end

    def self.pd(*data, &blk)
      write(hashify(*data, {}), &blk)
    end

    def self.mpd(*data, &blk)
      mwrite(@mtx, hashify(*data, {}), &blk)
    end

    def self.pdfm(file, m, *data, &blk)
      write(hashify(*data, :file => File.basename(file, ".rb"), :fn => m), &blk)
    end

    def self.mpdfm(file, m, *data, &blk)
      mwrite([@mtx, File.basename(file, ".rb"), m].compact.join("."), hashify(*data, :file => File.basename(file, ".rb"), :fn => m), &blk)
    end

    def self.pde(e, *data)
      ewrite(hashify(*data, errorify(e)))
    end

    def self.mpde(e, *data)
      mewrite(hashify(*data, errorify(e)))
    end

    def self.pdfme(file, m, e, *data)
      ewrite(hashify(*data, errorify(e).merge(:file => File.basename(file, ".rb"), :fn => m)))
    end

    def self.mpdfme(file, m, e, *data)
      mewrite(hashify(*data, errorify(e).merge(:file => File.basename(file, ".rb"), :fn => m)))
    end

    def self.errorify(e)
      { :at => "error", :class => e.class, :message => e.message.lines.to_a.first, :trace => e.backtrace.map { |i| i.match(/(#{Gem.dir}|#{Dir.getwd})?\/(.*):in (.*)/) && $2 }[0..5].compact.inspect}
    end

    def self.hashify(*data, initial)
      data.compact.reduce(initial.merge(@ctx || {})) { |d, v| d.merge v }
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
          v_str.match(/\s/) ? "#{k}=\'#{v_str}\'" : "#{k}=#{v_str}"
        end
      end.join(" ")
    end

    def self.ewrite(data)
      $stderr.puts stringify(data)
      $stderr.flush
    end

    def self.write(data, &blk)
      unless blk
        $stdout.puts stringify(data)
        $stdout.flush
      else
        start = Time.now
        write({ :at => "start" }.merge(data))
        yield.tap { write({ :at => "finish", :elapsed => Time.now - start }.merge(data)) }
      end
    end

    def self.mewrite(data)
      $stderr.puts stringify(data.tap { |d| d[:measure] = [@mtx, "error", d[:event]].compact.join(".") })
      $stderr.flush
    end

    def self.mwrite(tag, data, &blk)
      unless blk
        $stdout.puts stringify(data.tap { |d| d[:measure] = [tag, d[:event]].compact.join(".") if tag })
        $stdout.flush
      else
        start = Time.now
        write({ :at => "start" }.merge(data))
        yield.tap { elapsed = Time.now - start; mwrite(tag, { :at => "finish", :elapsed => elapsed }.merge(data).tap { |d| d[:val] = elapsed if tag }) }
      end
    end
  end
end
