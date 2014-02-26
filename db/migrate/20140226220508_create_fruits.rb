# db/migrate/20140226220508_create_fruits.rb

class CreateFruits < ActiveRecord::Migration
  def change

    # don't create default id; we want to create id:uuid
    create_table :fruits, id: false, force: true do |t|

      # use uuid_generate_v4 for random uuids
      t.uuid     :id, default: "uuid_generate_v4()", null: false
      t.text     :name

      # our time travel columns
      t.datetime :valid_from, null: false
      t.datetime :valid_to, null: false

      # lock_version as defined by http://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html
      t.integer  :lock_version, default: 0, null: false

      #
      # ** NO TIMESTAMPS **
      #
    end

    # for some reason create_table doesn't get this right....
    change_column  :fruits, :id, :uuid, null: false

    # create the primary key constraint
    execute "alter table fruits add primary key (id, lock_version)"

    # create the triggers to call the timetravel-esque functions
    execute <<-EOD
      CREATE TRIGGER fruits_before
      BEFORE INSERT OR UPDATE OR DELETE ON fruits
          FOR EACH ROW EXECUTE PROCEDURE process_timetravel_before();

      CREATE TRIGGER fruits_after
      AFTER UPDATE OR DELETE ON fruits
          FOR EACH ROW EXECUTE PROCEDURE process_timetravel_after();
    EOD
  end
end
