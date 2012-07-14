class Glossary < ActiveRecord::Base
  attr_accessible :description, :name

  validates_presence_of :name, :description
end
