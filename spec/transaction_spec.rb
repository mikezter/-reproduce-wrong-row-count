require 'mysql2'
require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection(
  adapter: :mysql2,
  hostname: 'localhost',
  username: 'root',
  database: 'database_cleaner_test'
)

SQL = 'create table if not exists `things` (
         `id` int(11) not null auto_increment,
         `name` varchar(255) not null,
         primary key (`id`)
      );'.freeze

ActiveRecord::Base.connection.execute SQL
DatabaseCleaner[:active_record].strategy = :deletion

Thing = Class.new(ActiveRecord::Base)
describe 'mysql2' do
  before { DatabaseCleaner.clean }

  it 'creates things' do
    Thing.create! name: 'anything'
    Thing.transaction do
      Thing.delete_all
      raise ActiveRecord::Rollback
    end
  end

  it 'finds nothing' do
    expect(Thing.count).to be 0 # fails
  end
end
