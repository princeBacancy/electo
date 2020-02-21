class ApplicationRecord < ActiveRecord::Base
  resourcify
  self.abstract_class = true
end
