require 'ostruct'
require 'set'

class DataModule

  cattr_accessor  :all_modules
  class_attribute :instances
  attr_accessor   :counter
  attr_reader     :config

  def self.configure(&block)
    self.all_modules ||= Set.new
    self.instances   ||= []

    instance = self.new
    all_modules << instance
    instances   << instance
    block.call(instance.config)
  end

  def self.update
    instances.map(&:update)
  end

  def self.initial_update
    instances.map(&:initial_update)
  end

  def initialize
    @counter = 0
    @config = OpenStruct.new
  end

  def update
    raise 'Not Implemented'
  end

  def initial_update
    raise 'Not Implemented'
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
