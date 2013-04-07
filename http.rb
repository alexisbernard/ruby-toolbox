# -*- encoding : utf-8 -*-

require 'net/http'

# Convenient way to fetch URLs. It follows redirection and handles SSL. Usage:
#   Net::HTTP.fetch_url('http://google.com')
#   Net::HTTP.fetch_url('https://www.google.fr/?q=ruby')
module Net
  class HTTP
    def self.fetch_url(url, headers = {}, limit = 10)
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      url = URI.parse(url)
      options = {use_ssl: url.scheme.downcase == 'https'}
      request = Net::HTTP::Get.new(url.request_uri)
      headers.each { |name, value| request[name] = value }
      response = Net::HTTP.start(url.host, url.port, options) { |http| http.request(request) }
      case response
      when Net::HTTPSuccess then response
      when Net::HTTPRedirection then fetch_url(response['location'], headers, limit - 1)
      else response.error!
      end
    end

    def self.fetch_url_as_chrome(url, headers = {}, limit = 10)
      headers["User-Agent"] ||= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
      fetch_url(url, headers, limit)
    end

    def self.head_url(url)
      url = URI.parse(url)
      options = {use_ssl: url.scheme.downcase == 'https'}
      Net::HTTP.start(url.host, url.port, options) { |http| http.head(url.request_uri) }
    end

    def self.url_exists?(url)
      Net::HTTP.head_url(url).is_a?(Net::HTTPOK)
    rescue Net::HTTPServerError, Errno::ETIMEDOUT, Timeout::Error, SocketError
      false
    end
  end
end
