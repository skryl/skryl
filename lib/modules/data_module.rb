require 'ostruct'
require 'set'

class DataModule

  class_attribute :config
  cattr_accessor  :configured
  attr_accessor   :counter

  def self.configure(&block)
    self.configured ||= Set.new
    self.config     ||= OpenStruct.new

    configured << self
    block.call(config)
  end

  def self.update
    new.update
  end

  def self.initial_update
    new.update
  end

  def initialize
    @counter = 0
  end

  def update
    railse 'Not Implemented'
  end

  def initial_update
    railse 'Not Implemented'
  end

private

  def save_and_increment(item)
    if item.valid?
      item.save
      @counter += 1
    else
      puts item.errors.full_messages
    end
    @counter
  end

end
