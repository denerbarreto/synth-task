class AddDefaultValuesToTokensAndResetPasswordTokens < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :tokens, from: nil, to: []
    change_column_default :users, :reset_password_tokens, from: nil, to: []
  end
end
