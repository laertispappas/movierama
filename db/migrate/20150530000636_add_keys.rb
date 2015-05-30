class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "comments", "users", name: "comments_user_id_fk"
  end
end
