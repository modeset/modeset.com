
ROOT_DIR           = File.expand_path(File.dirname(__FILE__))
PUBLIC_DIR         = File.join(ROOT_DIR, "public")

# Helpers
# -----------------------------------------------------------------------------
def self.curl_and_save(routes, dirname)
  pages = curl(routes)
  save(pages, dirname)
end

def self.curl(routes)
  pages = {}
  routes.each_pair do |key, value|
    pages[value] = `curl -# http://bittheory.dev/#{value}`
  end
  return pages
end

def self.save(pages, dirname)
  pages.each_pair do |key, value|
    File.open(File.join(dirname, "#{key}.html"), "w") do |file|
      puts("Writing #{dirname}/#{key}.html")
      file.write(value)
    end
  end
end

# Tasks
# -----------------------------------------------------------------------------
namespace :markup do
  desc "Generate static markup files from their haml templates"
  task :statics do
    pages = {:fourohfour => "404",
             :fivehundred => "500",
            }
    curl_and_save(pages, PUBLIC_DIR)
  end
end

