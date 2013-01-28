module LinkSpider
  def spider_from(path)
    begin
      visit(path)
    rescue Exception => e
      puts e.inspect
      raise e
    end

    all('a').each do |page_link|
      href = page_link[:href]

      next if href == '#'
      next if href.blank?
      next if ['delete','post','put'].include? page_link[:method] 
      next if href =~ /^http/
      next if href =~ /^(mailto|tel)/
      next if href == '/logout'

      if href =~ /^\//m
        visit(href)
      else
        visit("/#{href}")
      end

      expect(status_code).to be(200)

    end
  end

end
