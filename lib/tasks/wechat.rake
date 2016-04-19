require 'json'

namespace :wechat do
  desc "Create menu in official account"
  task :create_menu, [:file] => [:environment] do |t, args|
      Wechat::Menu.create JSON.parse(File.read(args[:file]))
  end

  desc "Create conditional menu in official account"
  task :create_menu_conditional, [:file, :group] => :environment do |t, args|
    menu = JSON.pare(File.read(args[:file]))
    Wechat::Menu.create_conditional menu, args[:group]
  end

  desc "List current menu difinitions for official account"
  task :list_menu => :environment do
    begin
      menus = Wechat::Menu.get
    rescue Wechat::Error => e
      # Catch the exception of 'no menu exist'
      if e.errcode == 46003 then puts 'No menu defined yet' else raise e end
    end
  end

  desc "Delete conditional menu"
  task :del_conditional_menu, [:menu_id] => :environment do |t, args|
    Wechat::Menu.delete_conditional args[:menu_id]
  end

  desc "Check the menu that is supposed to display for user"
  task :belongs_to_menu, [:open_id] => :environment do |t, args|
    menu = Wechat::Menu.test_conditional args[:open_id]
  end

  desc "List current groups for official account"
  task :list_group => :environment do
    Wechat::Group.get[:groups].each { |e|  puts "#{e[:name]}(#{e[:id]}): #{e[:count]}" }
  end

  desc "Create new named group"
  task :new_group, [:name] => :environment do |t, args|
    group = Wechat::Group.create args[:name]
    puts "Created a new group: #{group[:group][:name]}(#{group[:group][:id]})"
  end

  desc "Delete a group with [id]"
  task :del_group, [:id] => :environment do |t, args|
    group = Wechat::Group.delete args[:id]
    puts "Deleted the group: #{args[:id]}"
  end
end
