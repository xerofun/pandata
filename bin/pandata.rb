require 'optparse'
require_relative '../lib/scraper.rb'

options = {}
options[:data_to_get] = []

OptionParser.new do |opts|
  opts.banner = 'Usage: pandata.rb [options]'

  opts.on('--json', 'Return the results as JSON') do |json|
    options[:return_as_json] = json
  end

  opts.on('-i', '--identifier ID', 'Pandora email or webname') do |id|
    options[:id] = id
  end

  opts.on('-a', '--recent_activity', 'Retrieve recent activity') do
    options[:data_to_get] << :recent_activity
  end

  opts.on('-S', '--playing_station', 'Retrieve currently playing station') do
    options[:data_to_get] << :playing_station
  end

  opts.on('-s', '--stations', 'Retrieve all stations') do
    options[:data_to_get] << :stations
  end

  opts.on('-b', '--bookmarked_tracks', 'Retrieve all bookmarked tracks') do
    options[:data_to_get] << :bookmarked_tracks
  end

  opts.on('-B', '--bookmarked_artists', 'Retrieve all bookmarked artists') do
    options[:data_to_get] << :bookmarked_artists
  end

  opts.on('-l', '--liked_tracks', 'Retrieve all liked tracks') do
    options[:data_to_get] << :liked_tracks
  end

  opts.on('-L', '--liked_artists', 'Retrieve all liked artists') do
    options[:data_to_get] << :liked_artists
  end

  opts.on('-m', '--liked_albums', 'Retrieve all liked albums') do
    options[:data_to_get] << :liked_albums
  end

  opts.on('-n', '--liked_stations', 'Retrieve all liked stations') do
    options[:data_to_get] << :liked_stations
  end

  opts.on('-f', '--followers', 'Retrieve all followers of ID') do
    options[:data_to_get] << :followers
  end

  opts.on('-F', '--following', 'Retrieve all users being followed by ID') do
    options[:data_to_get] << :following
  end
end.parse!

if !options[:id]
  puts 'You must supply a webname or email to -i. See -h for help.'
  exit
end

scraper = Pandora::Scraper.get(options[:id])

if scraper.kind_of? Array
  puts "No direct matches for '#{options[:id]}'.\n\n"
  puts "Webnames with '#{options[:id]}' in the profile name:"
  puts scraper.map { |val| "- #{val}" }
  exit
else
  options[:data_to_get].each do |data_type|
    if /(bookmark|like)e?d_(.*)/ =~ data_type
      method = $1 + 's'
      arg = $2.to_sym
      p scraper.public_send(method, arg)
    else
      p scraper.public_send(data_type)
    end
  end
end
