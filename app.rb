require './scan.rb'

puts '1. Loading passwords...'
passwords = fill_passwords(file_path)

sleep 1

puts '2. Generating hosts...'
hosts = hosts_gen

puts 'Unable to generate' && return if hosts.empty?
puts 'Hosts seccesfully generated'

sleep 1

puts '3. Checking ICMP connection of our hosts...'
hosts = pingable_hosts(hosts)
puts 'Unable to generate' && return if hosts.empty?

puts 'ICMP connected hosts seccesfully detected'
puts '4. Checking SSH connection of icmp aval hosts...'
hosts = connectable_hosts(hosts)

puts '5. Scanning...'
scan(passwords, hosts)