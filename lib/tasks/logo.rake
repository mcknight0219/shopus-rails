namespace :logo do
  desc "Create new logo"
  task :new, [:name, :url] => [:environment] do |t, args|
    logo = Logo.new
    logo.name = args[:name]
    logo.url = args[:url]
    logo.save
    logo.fetch
  end

end
