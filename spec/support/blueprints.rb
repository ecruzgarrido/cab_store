require 'machinist/active_record'

Dir["#{Rails.root}/spec/blueprints/*.rb"].each do |file|
  require file
end
