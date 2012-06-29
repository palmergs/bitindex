module Bitindex
  module Common

    SIGNED_16BIT =   2**15 / 8
    UNSIGNED_16BIT = 2**16 / 8

    SIGNED_32BIT   = 2**31 / 8
    UNSIGNED_32BIT = 2**32 / 8

    def bit_set? byte, value, ltor = true
      mask = build_mask value, ltor
      (byte & mask) != 0
    end

    def set_bit byte, value, ltor = true
      mask = build_mask value, ltor
      (byte | mask)
    end
  
    def unset_bit byte, value, ltor = true
      mask = build_mask value, ltor
      mask ^= 0xff
      (byte & mask)
    end

    def byte_pos value
      (value >> 3)
    end

    def build_mask value, ltor = true
      shift = value & 0x07
      if ltor
        (0x80 >> shift)
      else
        (0x01 << shift)
      end
    end
  end
end
