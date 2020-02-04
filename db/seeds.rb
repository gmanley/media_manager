HostProvider.find_or_create_by(name: 'mega') do |m|
  m.url = 'https://mega.nz'
  m.default_storage_limit = 50.gigabytes
end

HostProvider.find_or_create_by(name: 'backblaze') do |m|
  m.url = 'https://www.backblaze.com/b2/cloud-storage.html'
end

User.find_or_create_by(username: 'admin') do |m|
  m.password = 'password'
  m.email = 'admin@example.com'
  m.role = 'admin'
end

User.find_or_create_by(username: 'contributor') do |m|
  m.password = 'password'
  m.email = 'contributor@example.com'
  m.role = 'contributor'
end

User.find_or_create_by(username: 'consumer') do |m|
  m.password = 'password'
  m.email = 'consumer@example.com'
  m.role = 'consumer'
end
