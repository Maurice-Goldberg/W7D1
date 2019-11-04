class DeleteUserIdColumnOnCats < ActiveRecord::Migration[5.2]
  def change
    remove_column :cats, :user_id
  end
end
