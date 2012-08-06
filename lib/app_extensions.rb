require 'ostruct'

module AppExtensions
  include ActiveSupport::Inflector

  def module_instances
    return unless config.modules
    config.modules.each do |module_sym|
      yield module_sym.to_s.camelize.constantize.new(config.send(module_sym))
    end
  end

  def for_module(sym)
    config.modules = [] unless config.modules
    config.modules << sym
    module_config = OpenStruct.new
    yield module_config
    config.send("#{sym}=", module_config)
  end
end

