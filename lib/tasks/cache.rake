namespace :cache do
  desc 'cache:refresh["3  / /home /shop/brands /shop/categories"]'
  task :refresh, [:options] => :environment do |t, args|
    options = args[:options].split
    level, $host, urls = options.delete_at(0).to_i, options.delete_at(0).match(/http:\/\/[^\/]+/).to_s, options
    $matrix = [urls.map { |url| {:url => url, :level => 0} }] + level.times.map { [] }
    while unparsed_page = ($matrix.find { |array| !array.map { |page| !!page[:parsed] }.inject(&:&) } || []).find { |page| !page[:parsed] } do
      while nobody_page = ($matrix.find { |array| !array.map { |page| !!page[:body] }.inject(&:&) } || []).find { |page| !page[:body] } do
        puts nobody_page[:url]
        get_body(nobody_page)
      end
      parse_page(unparsed_page)
    end
  end

  def parse_page(page)
    page[:parsed] = true
    return if page[:level] >= $matrix.size - 1

    doc = Nokogiri::HTML.parse(page[:body])
    level = page[:level] + 1

    $matrix[level] += (doc.css("a.prefetch, .prefetch a").map { |link| link.attributes['href'].text }.delete_if { |l| l.blank? || l == "#" }.uniq.compact - $matrix.flatten.map { |m| m[:url] }).map { |url| {:level => level, :url => url} }
  end

  def cache_path(url)
    url = url.match(/^\/shop\/products(\/|)(latest|men|women|)(\?|$)/) || url.match(/^\/shop\/(brands|categories)\/\d+/) ? Digest::MD5.hexdigest(url) : url
    url += 'index' if url =~ /\/$/
    "views/#{url}"
  end

  def get_body(page)
    page[:body] = Rails.cache.read(cache_path(page[:url])) rescue nil
    page[:body] ||= begin
      Timeout::timeout(30) do
        Mechanize.new.get($host + page[:url]).body
      end
    rescue Exception => e
      ''
    end
    page[:body] = '' if page[:level] >= $matrix.size - 1
  end

  desc 'cache clear'
  task :clear => :environment do
    Rails.cache.clear
  end
end
