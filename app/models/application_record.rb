# frozen_string_literal: true

# parent model
class ApplicationRecord < ActiveRecord::Base
  resourcify
  self.abstract_class = true
end
