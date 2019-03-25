module Paradoctor
  class Engine < ::Rails::Engine
    config.assets.precompile << "paradoctor.js"
  end
end
