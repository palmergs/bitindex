require 'spec_helper'

class BitIndexCommonTest; include Bitindex::Common; end

describe Bitindex::Common do

  before(:each) { @test = BitIndexCommonTest.new }

  describe '.set_bit' do
    it 'sets bits left to right' do
      @test.set_bit(0x00, 7).should == 0x01 # 0000 0001
      @test.set_bit(0x00, 0).should == 0x80 # 1000 0000
    end

    it 'sets bits right to left' do
      @test.set_bit(0x00, 7, false).should == 0x80 # 1000 0000
      @test.set_bit(0x00, 0, false).should == 0x01 # 0000 0001
    end    

    it 'does not modify other bits' do
      byte = 0x00
      (0..7).each {|n| byte = @test.set_bit(byte, n) }
      byte.should == 0xff
    end

    it 'does not modify a previously set bit' do
      @test.set_bit(0x88, 0).should == 0x88
      @test.set_bit(0x11, 0, false).should == 0x11
    end
  end

  describe '.unset_bit' do
    it 'unsets bits left to right' do
      @test.unset_bit(0xff, 7).should == 0xfe # 1111 1110
      @test.unset_bit(0xff, 0).should == 0x7f # 0111 1111
    end

    it 'unsets bits right to left' do
      @test.unset_bit(0xff, 7, false).should == 0x7f # 0111 1111
      @test.unset_bit(0xff, 0, false).should == 0xfe # 1111 1110
    end

    it 'does not modify other bits' do
      byte = 0xff
      (0..7).each {|n| byte = @test.unset_bit(byte, n) }
      byte.should == 0x00
    end

    it 'does not modify a previously unset bit' do
      @test.unset_bit(0x77, 0).should == 0x77 # 0111 0111
      @test.unset_bit(0xee, 0, false).should == 0xee # 1110 1110
    end
  end

  describe '.bit_set?' do
    it 'should determine if a bit within a byte is set' do
      (0..15).each {|n| @test.bit_set?(0x00, n).should == false }
      (0..15).each {|n| @test.bit_set?(0xff, n).should == true }
    end

    it 'finds set bit left to right' do
      byte = 0xf0 # 11110000
      (0..3).each {|n| @test.bit_set?(byte, n).should == true }
      (4..7).each {|n| @test.bit_set?(byte, n).should == false }
    end

    it 'finds set bit right to left' do
      byte = 0xf0 # 11110000
      (0..3).each {|n| @test.bit_set?(byte, n, false).should == false }
      (4..7).each {|n| @test.bit_set?(byte, n, false).should == true }
    end
  end
end
