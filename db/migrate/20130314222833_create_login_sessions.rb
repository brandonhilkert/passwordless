class CreateLoginSessions < ActiveRecord::Migration
  def change
    create_table :login_sessions do |t|
      t.string :email, null: false
      t.string :hashed_code, null: false
      t.string :ip
      t.string :user_agent
      t.timestamp :activated_at
      t.timestamp :terminated_at

      t.timestamps
    end
  end
end
