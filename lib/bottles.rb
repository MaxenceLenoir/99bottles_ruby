require 'pry'

class Bottles
  attr_reader :verse_template

  def initialize(verse_template: BottleVerse)
    @verse_template = verse_template
  end

  def song
    verses(99, 0)
  end

  def verses(upper, lower)
    upper.downto(lower).collect { |i| verse(i) }.join("\n")
  end

  def verse(number)
    verse_template.lyrics(number)
  end

  def quantity(number)
    BottleNumber.new(number).quantity
  end

  def container(number)
    BottleNumber.new(number).container
  end

  def action(number)
    BottleNumber.new(number).action
  end

  def successor(number)
    BottleNumber.new(number).successor
  end
end

class BottleNumber
  attr_reader :number

  def self.inherited(candidate)
    super(candidate)
    register(candidate)
  end

  def self.for(number)
    registry.find { |candidate| candidate.handles?(number) }.new(number)
  end

  def self.registry
    @registry ||= [self]
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  def initialize(number)
    @number = number
  end

  def self.handles?(_number)
    true
  end

  def to_s
    "#{quantity} #{container}"
  end

  def quantity
    number.to_s
  end

  def container
    'bottles'
  end

  def pronoun
    'one'
  end

  def action
    "Take #{pronoun} down and pass it around"
  end

  def successor
    BottleNumber.for(number - 1)
  end
end

class BottleNumber0 < BottleNumber
  def quantity
    'no more'
  end

  def action
    'Go to the store and buy some more'
  end

  def successor
    BottleNumber.for(99)
  end

  def self.handles?(number)
    number.zero?
  end
end

class BottleNumber1 < BottleNumber
  def container
    'bottle'
  end

  def pronoun
    'it'
  end

  def self.handles?(number)
    number == 1
  end
end

class BottleNumber6 < BottleNumber
  def container
    'six-pack'
  end

  def quantity
    '1'
  end

  def self.handles?(number)
    number == 6
  end
end

class BottleVerse
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def self.lyrics(number)
    new(number).lyrics
  end

  def lyrics
    bottle_number = BottleNumber.for(number)

    "#{bottle_number} of beer on the wall, ".capitalize +
    "#{bottle_number} of beer.\n" +
    "#{bottle_number.action}, " +
    "#{bottle_number.successor} " +
    "of beer on the wall.\n"
  end
end
