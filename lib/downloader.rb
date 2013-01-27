require 'net/http'
require 'uri'

module Pandora
  class Downloader
    COOKIES = ['at=wSS/+MM34vcWDcbXBjCHIEqaNLEkpjQwtMnlj1+17gagXRISD1d86ADo+5UQmTpLjN1p126cjZfw%3D']

    def read_page url
      uri = URI.parse URI.escape(url)

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = Downloader::COOKIES.sample  # Get a random cookie

      http.request(request).body
    end

  end
end
