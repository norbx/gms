class ChangeSocialLinksToJson < ActiveRecord::Migration[6.1]
  def up
    change_column :bands, :social_links, :json, using: 'social_links::json'
  end

  def down
    change_column :bands, :social_links, :text
  end
end
