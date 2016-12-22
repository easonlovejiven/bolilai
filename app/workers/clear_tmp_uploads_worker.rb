class ClearTmpUploadsWorker
  include Sidekiq::Worker

  def perform
    puts "clear tmp uploads"
    Upload.where("attachmentable_id is null").find_in_batches(batch_size: 100) do |uploads|
      file_keys=uploads.collect { |upload| "uploads/#{upload.file_key}" }
      ids=uploads.map(&:id)
      if Qiniu.batch("delete", "weimall", file_keys)
        Upload.delete_all(id: ids)
      end
    end
  end
end
