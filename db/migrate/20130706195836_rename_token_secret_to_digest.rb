class RenameTokenSecretToDigest < ActiveRecord::Migration
  def change
    rename_column :tokens, :secret, :digest
  end
end
