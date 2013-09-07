require "time"

module Press
  module Printer

    # context
    def self.ctx=(data)
      @ctx = data
    end

    # measure tag
    def self.mtx=(tag)
      @mtx = tag
    end

    # print data
    def self.pd(*data, &blk)
      write($stdout, hashify(*data, {}), &blk)
    end

    # measure print data
    def self.mpd(*data, &blk)
      mwrite($stdout, @mtx, hashify(*data, {}), &blk)
    end

    # measure print data
    def self.xpd(*data, &blk)
      xwrite($stdout, @mtx, hashify(*data, {}), &blk)
    end

    # sample print data
    def self.spd(*data)
      swrite($stdout, @mtx, hashify(*data, {}))
    end

    # count print data
    def self.cpd(*data)
      cwrite($stdout, @mtx, hashify(*data, {}))
    end

    # print data file method
    def self.pdfm(file, m, *data, &blk)
      write($stdout, hashify(*data, :file => File.basename(file, ".rb"), :fn => m), &blk)
    end

    # measure print data file method
    def self.mpdfm(file, m, *data, &blk)
      mwrite($stdout, [@mtx, File.basename(file, ".rb"), m].compact.join("."), hashify(*data, :file => File.basename(file, ".rb"), :fn => m), &blk)
    end

    # measure print data file method
    def self.xpdfm(file, m, *data, &blk)
      xwrite($stdout, [@mtx, File.basename(file, ".rb"), m].compact.join("."), hashify(*data, :file => File.basename(file, ".rb"), :fn => m), &blk)
    end

    # sample print data file method
    def self.spdfm(file, m, *data)
      swrite($stdout, [@mtx, File.basename(file, ".rb"), m].compact.join("."), hashify(*data, :file => File.basename(file, ".rb"), :fn => m))
    end

    # count print data file method
    def self.cpdfm(file, m, *data)
      cwrite($stdout, [@mtx, File.basename(file, ".rb"), m].compact.join("."), hashify(*data, :file => File.basename(file, ".rb"), :fn => m))
    end

    # print data exception
    def self.pde(e, *data)
      write($stderr, hashify(*data, errorify(e)))
    end

    # measure print data exception
    def self.mpde(e, *data)
      mwrite($stderr, [@mtx, "error"].compact.join("."), hashify(*data, errorify(e)))
    end

    # measure print data exception
    def self.xpde(e, *data)
      xwrite($stderr, [@mtx, "error"].compact.join("."), hashify(*data, errorify(e)))
    end

    # print data file method exception
    def self.pdfme(file, m, e, *data)
      write($stderr, hashify(*data, errorify(e).merge(:file => File.basename(file, ".rb"), :fn => m)))
    end

    # measure print data file method exception
    def self.mpdfme(file, m, e, *data)
      mwrite($stderr, [@mtx, "error"].compact.join("."), hashify(*data, errorify(e).merge(:file => File.basename(file, ".rb"), :fn => m)))
    end

    # measure print data file method exception
    def self.xpdfme(file, m, e, *data)
      xwrite($stderr, [@mtx, "error"].compact.join("."), hashify(*data, errorify(e).merge(:file => File.basename(file, ".rb"), :fn => m)))
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

    def self.write(file, data, &blk)
      unless blk
        file.puts stringify(data)
        file.flush
        nil
      else
        start = Time.now
        write(file, { :at => "start" }.merge(data))
        yield.tap do
          write(file, { :at => "finish", :elapsed => Time.now - start }.merge(data))
        end
      end
    end

    def self.xwrite(file, tag, data, &blk)
      unless blk
        write(file, data.tap { |d| d[:measure] = [tag, d[:event]].compact.join(".") if tag })
      else
        start = Time.now
        write(file, { :at => "start" }.merge(data))
        yield.tap do
          elapsed = Time.now - start;
          xwrite(file, tag, { :at => "finish", :elapsed => elapsed }.merge(data).tap { |d| d[:val] = elapsed if tag })
        end
      end
    end

    def self.mwrite(file, tag, data, &blk)
      unless blk
        write(file, data.tap { |d| d["measure.#{[tag, d[:event]].compact.join(".")}"] = d[:val] || 1 if tag })
      else
        start = Time.now
        write(file, { :at => "start" }.merge(data))
        yield.tap do
          elapsed = Time.now - start;
          mwrite(file, tag, { :at => "finish", :elapsed => elapsed }.merge(data).tap { |d| d[:val] = elapsed if tag })
        end
      end
    end

    def self.swrite(file, tag, data)
      write(file, data.tap { |d| d["sample.#{[tag, d[:event]].compact.join(".")}"] = d[:val] if tag })
    end

    def self.cwrite(file, tag, data)
      write(file, data.tap { |d| d["count.#{[tag, d[:event]].compact.join(".")}"] = d[:val] || 1 if tag })
    end
  end
end
