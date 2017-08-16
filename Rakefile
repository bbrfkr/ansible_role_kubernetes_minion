require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

def generate_ansible_inventory(name, host, port, user, pass, idkey, sudo_pass)
  ansible_inventory = name
  ansible_inventory += " ansible_host=#{ host }"
  ansible_inventory += " ansible_port=#{ port || 22 }"
  ansible_inventory += " ansible_user=#{ user || root }"
  if pass != nil
    ansible_inventory += " ansible_ssh_pass=#{ pass }"
  end
  if idkey != nil
    ansible_inventory += " ansible_ssh_private_key_file=#{ pass }"
  end
  if sudo_pass != nil
    ansible_inventory += " ansible_become_pass=#{ sudo_pass }"
  end

  return ansible_inventory + "\n"
end

def copy_role_for_spec
  copy_dest = "spec/roles/bbrfkr.kubernetes_minion"
  if not Dir.exist?(copy_dest)
    fileutils.mkdir_p(copy_dest)
  end
  delete_targets = Dir.glob(copy_dest + '/*')
  FileUtils.rm_rf(delete_targets)
  copy_targets = Dir.glob('*')
  copy_targets.delete('spec')
  FileUtils.cp_r(copy_targets, copy_dest)
end

def clone_common_role_for_spec
  copy_dest = "spec/roles/bbrfkr.kubernetes_common"
  if not Dir.exist?(copy_dest)
    FileUtils.mkdir_p(copy_dest)
  end
  delete_targets = Dir.glob(copy_dest)
  FileUtils.rm_rf(delete_targets)
  system("cd spec/roles && git clone https://github.com/bbrfkr/ansible_role_kubernetes_common.git bbrfkr.kubernetes_common")
end

def clone_master_role_for_spec
  copy_dest = "spec/roles/bbrfkr.kubernetes_master"
  if not Dir.exist?(copy_dest)
    FileUtils.mkdir_p(copy_dest)
  end
  delete_targets = Dir.glob(copy_dest)
  FileUtils.rm_rf(delete_targets)
  system("cd spec/roles && git clone https://github.com/bbrfkr/ansible_role_kubernetes_master.git bbrfkr.kubernetes_master")
end

task :default => :spec
task :spec => 'spec:all'

namespace :spec do
  connections = YAML.load_file("spec/inventory.yml")

  conn_hosts = [connections[0]['conn_name']]

  task :all => conn_hosts

  copy_role_for_spec
  clone_common_role_for_spec
  clone_master_role_for_spec


  desc "Run serverspec to the connection for test #{ connections[0]['conn_name']}"
  RSpec::Core::RakeTask.new(connections[0]['conn_name'].to_sym) do |t|
    ENV['CONN_NAME'] = connections[0]['conn_name']
    ENV['CONN_HOST'] = connections[0]['conn_host']
    ENV['CONN_PORT'] = connections[0]['conn_port'].to_s || '22'
    ENV['CONN_USER'] = connections[0]['conn_user'] || 'root'
    ENV['CONN_PASS'] = connections[0]['conn_pass']
    ENV['CONN_IDKEY'] = connections[0]['conn_idkey']
    ENV['SUDO_PASS'] = connections[0]['sudo_pass']
    File.open('spec/inventory', 'w') do |f|
      ansible_inventory_minion =
        generate_ansible_inventory(
          connections[0]['conn_name'],
          connections[0]['conn_host'],
          connections[0]['conn_port'],
          connections[0]['conn_user'],
          connections[0]['conn_pass'],
          connections[0]['conn_idkey'],
          connections[0]['sudo_pass']
        )
      ansible_inventory_master =
        generate_ansible_inventory(
          connections[1]['conn_name'],
          connections[1]['conn_host'],
          connections[1]['conn_port'],
          connections[1]['conn_user'],
          connections[1]['conn_pass'],
          connections[1]['conn_idkey'],
          connections[1]['sudo_pass']
        )
      f.puts(ansible_inventory_minion + ansible_inventory_master)
    end

    t.pattern = "spec/spec_dirs/#{ connections[0]['conn_name'] }/*_spec.rb"
  end
end

