require 'json'
require 'open-uri'

module Pandata

  # Retrieves data from Pandora and handles errors.
  class Downloader
    # A GitHub Gist that contains an updated cookie allowing access to 'login-only' visible data.
    CONFIG_URL = 'https://gist.github.com/ustasb/596f1ee96d03463fde77/raw/pandata_config.json'

    class << self
      attr_accessor :cookie
    end

    # Gets a cookie allowing access to Pandora's data and returns a Downloader instance.
    def initialize
      # If we already have a cookie, don't get another.
      unless Downloader.cookie
        Downloader.cookie = get_cookie
      end
    end

    # Downloads a page and returns its content as a string.
    def read_page(url)
      safe_open(url, Downloader.cookie).read
    end

    private

    # Downloads a page and handles errors.
    def safe_open(url, cookie = '')
      escaped_url = URI.escape(url)

      begin
        open(escaped_url, 'Cookie' => cookie, :read_timeout => 5)
      rescue OpenURI::HTTPError => error
        puts "The network request for:\n  #{url}\nreturned an error:\n  #{error.message}"
        puts "Please try again later or update Pandata. Sorry about that!\n\nFull error:"
        raise error
      end
    end

    def get_cookie
      config = JSON.parse safe_open(CONFIG_URL).read
      config['cookie']
    end
  end
end
