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
      write $stdout, hashify(*data, {}), &blk
    end

    def self.mpd(*data, &blk)
      mwrite $stdout, @mtx, hashify(*data, {}), &blk
    end

    def self.pdfm(file, m, *data, &blk)
      write $stdout, hashify(*data, :file => File.basename(file, ".rb"), :fn => m), &blk
    end

    def self.mpdfm(file, m, *data, &blk)
      mwrite $stdout, [@mtx, File.basename(file, ".rb"), m].compact.join("."), hashify(*data, :file => File.basename(file, ".rb"), :fn => m), &blk
    end

    def self.pde(e, *data)
      write $stderr, hashify(*data, :at => "error", :class => e.class, :message => e.message.lines.to_a.first, :trace => e.backtrace.map { |i| i.match(/(#{Gem.dir}|#{Dir.getwd})?\/(.*):in (.*)/) && $2 }[0..5].compact.inspect)
    end

    def self.mpde(e, *data)
      mwrite $stderr, [@mtx, "error"].compact.join("."), hashify(*data, :at => "error", :class => e.class, :message => e.message.lines.to_a.first, :trace => e.backtrace.map { |i| i.match(/(#{Gem.dir}|#{Dir.getwd})?\/(.*):in (.*)/) && $2 }[0..5].compact.inspect)
    end

    def self.pdfme(file, m, e, *data)
      write $stderr, hashify(*data, :at => "error", :class => e.class, :message => e.message.lines.to_a.first, :trace => e.backtrace.map { |i| i.match(/(#{Gem.dir}|#{Dir.getwd})?\/(.*):in (.*)/) && $2 }[0..5].compact.inspect, :file => File.basename(file, ".rb"), :fn => m)
    end

    def self.mpdfme(file, m, e, *data)
      mwrite $stderr, [@mtx, "error"].compact.join("."), hashify(*data, :at => "error", :class => e.class, :message => e.message.lines.to_a.first, :trace => e.backtrace.map { |i| i.match(/(#{Gem.dir}|#{Dir.getwd})?\/(.*):in (.*)/) && $2 }[0..5].compact.inspect, :file => File.basename(file, ".rb"), :fn => m)
    end

    def self.hashify(*data, initial)
      data.compact.reduce(initial.merge(@ctx || {})) { |d, v| d.merge v }
    end

    def self.mtag(tag, data)
      data.tap { |d| d[:measure] = [tag, d[:event]].compact.join(".") if tag }
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
        write file, { :at => "start" }.merge(data)
        yield.tap { write file, { :at => "finish", :elapsed => Time.now - start }.merge(data) }
      end
    end

    def self.mwrite(file, tag, data, &blk)
      unless blk
        file.puts stringify(mtag(tag, data))
        file.flush
      else
        start = Time.now
        write file, { :at => "start" }.merge(data)
        yield.tap do
          elapsed = Time.now - start
          mwrite file, tag, { :at => "finish", :elapsed => elapsed }.merge(data).tap { |d| d[:val] = elapsed if tag }
        end
      end
    end
  end
end
