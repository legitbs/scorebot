namespace :scoreboard do
  desc 'Export the current scoreboard to a ctftime compatible json' 
  task :export => :environment do
    File.open(Rails.root.join('tmp', '2014_finals.json'), 'w') do |f|
      f.write Team.as_standings_json.to_json
    end
  end

  desc 'Upload the current scoreboard to legitbs.net'
  task :upload => :environment do
    s3 = Fog::Storage.new(provider: 'AWS',
                          aws_access_key_id: ENV['AWS_ACCESS_KEY'],
                          aws_secret_access_key: ENV['AWS_SECRET_KEY'],
                          path_style: true
                          )
# binding.pry
    bucket = s3.directories.get 'live.legitbs.net'
    bucket.files.create(key: '2014_finals.json',
                        content_type: 'text/json',
                        body: Team.as_standings_json.to_json
                        )
  end
end
