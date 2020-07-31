class Photo < ApplicationRecord
    belongs_to :show

    mount_uploader :filename, PhotoUploader
end
