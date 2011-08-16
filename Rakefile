
ROOT_DIR           = File.expand_path(File.dirname(__FILE__))
PUBLIC_DIR         = File.join(ROOT_DIR, "public")

IMAGES_DIR         = File.join(PUBLIC_DIR, "images")

JS_SOURCE_DIR      = File.join(ROOT_DIR, "app/javascripts")
JS_APP_DIR         = File.join(JS_SOURCE_DIR, "app")
JS_LIB_DIR         = File.join(JS_SOURCE_DIR, "libs")
JS_OUTPUT_DIR      = File.join(PUBLIC_DIR, "javascripts")

JS_FILES           = ["#{JS_LIB_DIR}/underscore.js",
                      "#{JS_LIB_DIR}/backbone.js",
                      "#{JS_APP_DIR}/config/namespace.js",
                      "#{JS_APP_DIR}/views/document_view.js",
                      "#{JS_APP_DIR}/views/navigation_view.js",
                      "#{JS_APP_DIR}/views/section_view.js",
                      "#{JS_APP_DIR}/config/routes.js"]

DEPS_DIR           = File.join(ROOT_DIR, "deps")
PNG_TOOLS          = File.join(DEPS_DIR, "pngtools")
JPEG_TOOLS         = File.join(DEPS_DIR, "jpegtools")
GIF_TOOLS          = File.join(DEPS_DIR, "giftools")

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

def self.concatenate(files, output)
  File.open(output, "w") do |file|
    files.each do |f|
      file.write(File.read(f))
      file.write("\n")
    end
  end
  puts("Concatenated #{output}")
end


def self.compress(dirname)
  puts("Compressing images in #{dirname}")
  Dir["#{dirname}/**/*.{png,jpeg,jpg,gif}"].each do |file|
    if File.extname(file) == ".png" && File.basename(file) != "content-box.png"
      system "#{PNG_TOOLS}/optipng -o7 -q #{file}"
      system "#{PNG_TOOLS}/advpng -z -4 -q  #{file}"
      system "#{PNG_TOOLS}/pngout -q #{file}"
    end
    if File.extname(file) == ".jpg" or File.extname(file) ==  ".jpeg"
      system "#{JPEG_TOOLS}/jpegoptim --strip-all -q #{file}"
    end
    if File.extname(file) ==  ".gif"
      system "#{GIF_TOOLS}/gifsicle --batch #{file}"
    end
    puts "Compressed #{file}"
  end
end

# Tasks
# -----------------------------------------------------------------------------
task :default => ["deploy:prep"]

namespace :markup do
  desc "Generate static markup files from their haml templates"
  task :statics do
    pages = {:fourohfour => "404",
             :fivehundred => "500",
            }
    curl_and_save(pages, PUBLIC_DIR)
  end
end

namespace :js do
  desc "Concatenate the javascripts into a single file"
  task :concat do
    concatenate(JS_FILES, "#{JS_OUTPUT_DIR}/app.js")
  end

  desc "Uglify the concatenated app.js"
  task :uglify do
    system "uglifyjs --overwrite #{JS_OUTPUT_DIR}/app.js"
  end
end

namespace :images do
  desc "Compress the images"
  task :compress do
    compress(IMAGES_DIR)
  end
end

namespace :deploy do
  desc "Run the tasks before running a deployment"
  task :prep => ["markup:statics","js:concat", "js:uglify"]

  desc "Deploy app to heroku's staging branch"
  task :staging  do
    system "git push staging master"
  end

  desc "Deploy app to heroku's production branch"
  task :production  do
    puts "production is not ready"
    # system "git push production master"
  end

end

