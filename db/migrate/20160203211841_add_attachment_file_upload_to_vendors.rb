class AddAttachmentFileUploadToVendors < ActiveRecord::Migration
  def self.up
    change_table :vendors do |t|
      t.attachment :file_upload
    end
  end

  def self.down
    remove_attachment :vendors, :file_upload
  end
end
