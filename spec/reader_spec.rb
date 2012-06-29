require 'spec_helper'

describe Bitindex::Reader do

  describe '.initialize' do
    it 'requires a valid file path' do
      expect { Bitindex::Reader.new }.to raise_error
      expect { Bitindex::Reader.new 'not_there.bit' }.to raise_error

      filepath = 'is_there.bit'
      FileUtils.touch filepath
      r = Bitindex::Reader.new filepath
      r.filepath.should == filepath
      FileUtils.rm filepath 
    end
    
    it 'can set left to right as an option' do

      filepath = 'is_there.bit'
      FileUtils.touch filepath

      r = Bitindex::Reader.new filepath
      r.ltor.should be_true

      r = Bitindex::Reader.new filepath, { ltor: false }
      r.ltor.should be_false

      FileUtils.rm filepath 
    end
  end

  describe '.is_set?' do
    it 'can read values in a single byte file' do
      
      filepath = 'reader.bit'
      File.open(filepath, 'wb') do |io|
        io.putc 0x88 # 1000 1000
      end

      r = Bitindex::Reader.new filepath
      r.is_set?(0).should be_true
      r.is_set?(1).should be_false
      r.is_set?(3).should be_false
      r.is_set?(4).should be_true
      r.is_set?(5).should be_false
      r.is_set?(7).should be_false

      
      r = Bitindex::Reader.new filepath, { ltor: false }
      r.is_set?(0).should be_false
      r.is_set?(1).should be_false
      r.is_set?(3).should be_true
      r.is_set?(4).should be_false
      r.is_set?(5).should be_false
      r.is_set?(7).should be_true

      FileUtils.rm filepath
    end

    it 'can read values in a multi-byte file' do

      filepath = 'reader.bit'

      # 1111 1111 0000 0000 1000 1000
      File.open(filepath, 'wb') do |io|
        io.putc 0xff
        io.putc 0x00
        io.putc 0x88
      end

      r = Bitindex::Reader.new filepath
      r.is_set?(0).should be_true
      r.is_set?(8).should be_false
      r.is_set?(16).should be_true
      r.is_set?(24).should be_false

      r = Bitindex::Reader.new filepath, { ltor: false }
      r.is_set?(0).should be_true
      r.is_set?(8).should be_false
      r.is_set?(16).should be_false
      r.is_set?(24).should be_false

      FileUtils.rm filepath
    end
  end

  describe '.all_set' do
    it 'can read values in a single byte file' do
      filepath = 'reader.bit'
      File.open(filepath, 'wb') do |io|
        io.putc 0x77 # 0111 0111
      end    

      r = Bitindex::Reader.new filepath
      r.all_set(0..10).should == [1,2,3,5,6,7]

      r = Bitindex::Reader.new filepath, ltor: false
      r.all_set(0..10).should == [0,1,2,4,5,6]

      FileUtils.rm filepath
    end

    it 'can read values in a multi-byte file' do
      filepath = 'reader.bit'
      # 1111 1111 0000 0000 1000 1000
      File.open(filepath, 'wb') do |io|
        io.putc 0xff
        io.putc 0x00
        io.putc 0x88
      end

      r = Bitindex::Reader.new filepath
      r.all_set(0..100).should == [0,1,2,3,4,5,6,7,16,20]

      r = Bitindex::Reader.new filepath, ltor: false
      r.all_set(0..100).should == [0,1,2,3,4,5,6,7,19,23]

      FileUtils.rm filepath
    end
  end
end
