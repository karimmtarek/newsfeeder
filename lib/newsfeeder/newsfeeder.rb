require 'mechanize'
require 'httparty'
require 'zip'
require 'redis'
require 'progress_bar'

module Newsfeeder
  class Newsfeeder
    attr_reader :redis, :http_folder_url, :news_list_name, :temp_local_dir

    def initialize(redis: nil, http_folder_url: nil, news_list_name: nil)
      @redis = redis || Redis.new
      @http_folder_url = http_folder_url || 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/'
      @news_list_name = news_list_name || 'NEWS_XML'
      @temp_local_dir = time_stamp
    end

    def redis_feeder(items:)
      download_files(number: items)

      files = Dir.glob("*.zip")
      bar = ProgressBar.new(files.size)
      puts "Reading #{files.size} zip files"
      prev_count = news_count
      files.each do |file_name|
        path = "#{Dir.pwd}/#{file_name}"
        next if File.zero?(file_name)
        read_zip(path: file_name)
        bar.increment!
      end
      new_count = news_count - prev_count
      puts "Done reading #{files.size} zip files! #{new_count} new news item"\
        " has been added to '#{news_list_name}' Redis list."\
        " Total news items: #{news_count}."
      change_to_app_root
    end

    private

    def change_to_app_root
      Dir.chdir('..')
      Dir.chdir('..')
      puts "Changed directory: #{Dir.pwd}"
    end

    def links(folder_url: http_folder_url)
      Mechanize.new.get(folder_url).links
    end

    def time_stamp
      DateTime.now.strftime("%Y%m%d%H%M%S")
    end

    def zip_links
      links.select { |link| link.text.include?('.zip') }
    end

    def create_and_change_dir(name:)
      if Dir.exists?(name)
        puts "Skipping creating directory #{name}. It already exists."
      else
        Dir.mkdir(name)
        puts "Directory #{name} created!"
      end

      Dir.chdir(name)
      puts "Changed directory: #{Dir.pwd}"
    end

    def setup_directory
      create_and_change_dir(name: 'tmp_zip')
      create_and_change_dir(name: temp_local_dir)
    end

    def download_files(number:)
      setup_directory
      if number == :all
        remote_files_links = zip_links
      else
        remote_files_links = zip_links.sample(number)
      end
      puts "Downloading #{remote_files_links.size} remote zip files..."

      bar = ProgressBar.new(remote_files_links.size)

      remote_files_links.each do |link|
        file = open(link.text, 'w')
        zip_content = HTTParty.get("#{http_folder_url}#{link.uri.to_s}").body
        file.write(zip_content)
        file.close
        bar.increment!
      end
    end

    def read_zip(path:)
      Zip::File.open(path) do |file|
        file.each do |content|
          data = file.read(content)
          add_news(item: data)
        end
      end
    end

    def news_count
      redis.zcard(news_list_name)
    end

    def add_news(item:)
      redis.zadd(news_list_name, 1, item)
    end
  end
end
