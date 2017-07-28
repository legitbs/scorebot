class Replacement < ApplicationRecord
  belongs_to :team
  belongs_to :service
  belongs_to :round

  before_save :process_upload

  attr_accessor :file

  MAX_SIZE = (ENV['MAX_REPLACEMENT_SIZE'] || (2 * 1024 * 1024)).to_i # 2mb
  DIGEST_BLOCK = 1024

  SERVICE_ROOT = ENV['SERVICE_ROOT'] || Rails.root.join("tmp", "services")
  ARCHIVE_ROOT = ENV['ARCHIVE_ROOT'] || Rails.root.join("tmp", "archive")


  def service_path
    File.join service.name, "#{service.name}.bin"
  end

  def archive_path
    File.join SERVICE_ROOT, "#{team_id}-#{service_id}-#{digest}.bin"
  end


  private

  def process_upload
    raise 'attach a file' unless file
    raise 'too fat' if file.size > MAX_SIZE

    self.size = file.size

    hash_fn = Digest::SHA256.new
    file.rewind
    until file.eof?
      hash_fn.update file.read(DIGEST_BLOCK)
    end
    self.digest = hash_fn.hexdigest

    FileUtils.mkdir_p(File.dirname(archive_path))
    # FileUtils.mkdir_p(File.dirname(service_path))

    FileUtils.cp file.path, archive_path
    # FileUtils.cp file.path, service_path

    scp = Cocaine::CommandLine.
           new('scp',
               file.path,
               ":dest")

    dest = "root@#{team.address}:/home/#{service.name}/#{service.name}.bin"

    scp.run dest: dest
  end
end
