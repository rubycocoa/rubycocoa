
module TestHelper

  def __spawn_line(line)
    cmd = "#{@ruby_path} -I../lib -I../ext/rubycocoa -e \"#{line}\""
    cmd = cmd_with_dyld_env(cmd)
    res = IO.popen(cmd) {|io| io.read}
    raise "Can't spawn Ruby line: '#{line}'" unless $?.success?
    return res.strip
  end

  # run command with DYLD_ environments via `env` command.
  # OS X 10.11 does not pass DYLD_ environments to subprocess.
  def cmd_with_dyld_env(cmd, env=ENV)
    cmd_via_env = ['/usr/bin/env']
    env.each_pair do |env_name, env_value|
      next unless env_name =~ /\ADYLD_/
      cmd_via_env << "#{env_name}=#{env_value}"
    end
    if cmd_via_env.size > 1
      cmd_via_env << cmd
      cmd_via_env.join(' ')
    else
      cmd
    end
  end

  # load .bridgesupport from "test/bridgesupport"
  def load_bridge_support_file(bs_name)
    bs_dir = File.expand_path('../bridgesupport', __FILE__)
    OSX.load_bridge_support_file(File.join(bs_dir, bs_name))
  end
  module_function :load_bridge_support_file

end
