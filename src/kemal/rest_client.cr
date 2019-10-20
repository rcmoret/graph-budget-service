require "http"

module Rest
  class Client
    BASE_URL = "http://localhost:8088"

    def self.get(path)
      HTTP::Client.get("#{BASE_URL}/#{path}")
    end
  end
end
