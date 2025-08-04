class AddImageUrlToPrizes < ActiveRecord::Migration[7.1]
  def change
    add_column :prizes, :image_url, :string
  end
end
