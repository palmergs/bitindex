require 'spec_helper'

describe Bitindex::Writer do

  describe '.initialize' do
    it 'requires a filepath and size' do
      expect { Bitindex::Writer.new }.to raise_error
      expect { Bitindex::Writer.new 'file.bit' }.to raise_error
      expect { Bitindex::Writer.new 10 }.to raise_error
      w = Bitindex::Writer.new 'file.bit', 10
      w.filepath.should == 'file.bit'
      w.size.should == 10
    end

    it 'can set "left to right" as an option' do
      w = Bitindex::Writer.new 'file.bit', 10
      w.ltor.should be_true

      w = Bitindex::Writer.new 'file.bit', 10, { ltor: false }
      w.ltor.should be_false
    end
  end

  describe '.write' do
    it 'writes a single byte file' do
      filepath = 'file.bit'
      w = Bitindex::Writer.new filepath, 1
      w.write [0, 1, 5, 7]
      
      File.open(filepath, 'rb') do |io|
        io.size.should == 1
        io.getbyte.should == 0xc5  # 1100 0101
      end
  
      FileUtils.rm filepath
    end

    it 'writes a multi-byte file' do
      filepath = 'file.bit'
      w = Bitindex::Writer.new filepath, 3
      w.write [0,1,2,3,4,5,6,7,16]
      
      File.open(filepath, 'rb') do |io|
        io.size.should == 3
        io.getbyte.should == 0xff
        io.getbyte.should == 0x00
        io.getbyte.should == 0x80
      end

      FileUtils.rm filepath
    end
  end
end
