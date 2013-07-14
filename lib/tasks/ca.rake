namespace :ca do
  desc "Output JSON for the certificate authority to generate client certs"
  task :json => :environment do
    out = Team.all.map(&:as_ca_json).to_json
    File.open(Rails.root.join('tmp', 'ca_teams.json'), 'w') do |f|
      f.write out
    end
  end
end
