require 'active_record'

ActiveRecord::Base.establish_connection(YAML.load_file("config/database.yml")[ENV["ENVIRONMENT"]])

class User < ActiveRecord::Base
  has_many :subjects
  self.table_name = 'users'
end

class Subject < ActiveRecord::Base
  belongs_to :users
  self.table_name = 'subjects'
end