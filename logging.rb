#TODO распарсить 2 последних октета
#Вопрос о паралельности
require 'bundler/inline'
require 'date'
gemfile do
  source 'https://rubygems.org'
  gem 'net-ssh'
end


file_path = './data/logs.txt'
if File.exist?(file_path)
  file = File.new(file_path, 'r:UTF-8')
  host = file.readlines
  file.close
  

  LOGIN = 'admin'.freeze
  PASSWORDS = %w[Cisco123 cisco123 Cisco123! cisco123 Admin@huawei admin@huawei D33vice].freeze
  PASSWORDS.each do |pwd|
    start_time = DateTime.now
    (1..254).each do |i|
      (1..254).each do |j|
        host = "192.168.#{i}.#{j}"
        begin
          Net::SSH.start(host, LOGIN, password: pwd, timeout: 5) do |_ssh|
          puts "host: #{host} password: #{pwd}"
        end
        rescue StandardError => e
        puts "err: #{e}"
      end
    end
  diff = ((DateTime.now - start_time) * 24 * 60 * 60).to_i
  sleep(310 - diff) if diff < 310
  end
else

end