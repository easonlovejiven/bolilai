module ActiveResource
  class ConnectionError < StandardError # :nodoc:
    def to_s
      "Failed with #{response.code if response.respond_to?(:code)} #{response.message if response.respond_to?(:message)}"
    end
  end
end
