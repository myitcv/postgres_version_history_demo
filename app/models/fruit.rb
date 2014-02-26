# app/models/fruit.rb

class Fruit < ActiveRecord::Base

  # we have overridden the default primary_key
  # even though lock_version is strictly part of the
  # primary key, its use happens behind the scenes
  self.primary_key = :id

  # by default, when searching and finding bits of fruit
  # we want the latest version
  default_scope { where(valid_to: 'infinity').reorder('') }
end
