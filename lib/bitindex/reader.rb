module Bitindex
  class Reader
    include Bitindex::Common

    attr_reader :filepath
    attr_accessor :ltor

    def initialize filepath, opts = {}

      raise "#{ filepath } is not readable" unless filepath and File.readable?(filepath)
      @filepath = filepath

      @ltor = !(opts[:ltor] == false)
    end

    def is_set? value
      result = false
      File.open(self.filepath, 'rb') do |io|
        idx = byte_pos value
        if idx < io.size
          io.seek idx, IO::SEEK_SET
          result = bit_set? io.getbyte, value, self.ltor
        end
      end
      result
    end

    def all_set array
      arr = []
      File.open(self.filepath, 'rb') do |io|
        cur_idx = nil
        cur_byte = nil
        array.each do |n|
          idx = byte_pos n
          if idx < io.size
            if cur_idx.nil? or cur_idx < idx
              io.seek idx, IO::SEEK_SET
              cur_byte = io.getbyte
            end
            arr << n if bit_set? cur_byte, n, self.ltor
          end
        end
      end
      arr
    end
  end
end
