module Bitindex
  class Writer
    include Bitindex::Common

    attr_reader :filepath, :size
    attr_accessor :ltor

    def initialize filepath, size, opts = {}
      raise "#{ size } is invalid size" unless size and size.to_i > 0
      @size = size

      raise "#{ filepath } is invalid file" unless filepath
      @filepath = filepath

      @ltor = !(opts[:ltor] == false)
    end

    def write sorted
      File.open(self.filepath, 'wb') do |io|
        last_num = nil
        cur_byte = 0
        cur_idx = 0
        sorted.each do |n|
          raise "values must be sorted" unless last_num.nil? or n >= last_num
          
          idx = byte_pos n
          if idx < self.size
            if idx > cur_idx
              io.putc cur_byte
              pad_to_pos io, cur_idx, idx - 1
              cur_idx = idx
              cur_byte = 0
            end

            cur_byte = set_bit cur_byte, n, self.ltor
          end          
        end

        io.putc cur_byte
        pad_to_pos io, cur_idx, self.size - 1 if cur_idx < self.size - 1
      end
    end

protected

    def pad_to_pos io, start, last
      while start < last
        io.putc 0
        start += 1
      end
    end
  end
end
