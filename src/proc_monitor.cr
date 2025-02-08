require "json"

struct ProcessInfo
  property pid : Int32
  property user : String
  property cpu : Float64
  property mem : Float64
  property command : String

  def initialize(@pid, @user, @cpu, @mem, @command)
  end

  def self.list_all
    output = IO::Memory.new
    Process.run("ps", ["-eo", "pid,user,%cpu,%mem,comm", "--no-headers"], output: output)
    output.rewind

    processes = [] of ProcessInfo
    output.gets_to_end.each_line do |line|
      parts = line.split.reject(&.empty?)
      next unless parts.size >= 5

      processes << ProcessInfo.new(
        parts[0].to_i,
        parts[1],
        parts[2].to_f,
        parts[3].to_f,
        parts[4..].join(" ")
      )
    end
    processes
  end

  def self.find_by_name(name : String)
    list_all.select { |proc| proc.command.downcase.includes?(name.downcase) }
  end

  def self.kill_process(pid : Int32)
    Process.run("kill", ["-9", pid.to_s])
  end

  def to_json(json : JSON::Builder)
    json.object do
      json.field "pid", pid
      json.field "user", user
      json.field "cpu", cpu
      json.field "mem", mem
      json.field "command", command
    end
  end

  def format_percentage(value : Float64) : String
    formatted = sprintf("%.1f%%", value).rjust(6)
    case value
    when 0.0..30.0
      "\033[32m#{formatted}\033[0m"
    when 30.0..70.0
      "\033[33m#{formatted}\033[0m"
    else
      "\033[31m#{formatted}\033[0m"
    end
  end

  def format_line
    pid_str = pid.to_s.ljust(8)
    user_str = user.ljust(15)
    cpu_str = format_percentage(cpu)
    mem_str = format_percentage(mem)
    "#{pid_str}#{user_str}#{cpu_str} #{mem_str} #{command}"
  end
end

def show_banner
  puts "\n\033[1;34m╔══════════════════════════════════╗"
  puts "║      Process Monitor v1.0         ║"
  puts "╚══════════════════════════════════╝\033[0m\n"
end

def print_header
  puts "\n\033[1m#{"PID".ljust(8)} #{"USER".ljust(15)} #{"CPU".rjust(8)} #{"MEM".rjust(8)} COMMAND\033[0m"
  puts "\033[90m#{"-" * 80}\033[0m"
end

if ARGV.empty? || ARGV.includes?("--help")
  show_banner
  puts <<-HELP
  \033[1mUsage: proc_monitor [options]\033[0m

  Available options:
    \033[1m--list\033[0m                List all processes
    \033[1m--search\033[0m <name>       Search processes by name
    \033[1m--kill\033[0m <PID>          Kill a process by PID
    \033[1m--json\033[0m                Display output in JSON format
  HELP
  exit
end

show_banner

if ARGV.includes?("--list")
  processes = ProcessInfo.list_all
  if ARGV.includes?("--json")
    puts processes.to_json
  else
    print_header
    processes.each { |p| puts p.format_line }
    puts "\n\033[90mTotal processes: #{processes.size}\033[0m"
  end
elsif ARGV.includes?("--search")
  search_index = ARGV.index("--search")
  if search_index.nil? || search_index + 1 >= ARGV.size
    puts "\033[31mError: You must provide a process name to search.\033[0m"
    exit 1
  end

  name = ARGV[search_index + 1]
  puts "\n\033[1mSearching for processes containing: \033[36m#{name}\033[0m\033[1m...\033[0m\n"
  
  processes = ProcessInfo.find_by_name(name)
  if processes.any?
    print_header
    processes.each { |p| puts p.format_line }
    puts "\n\033[90mProcesses found: #{processes.size}\033[0m"
  else
    puts "\033[33mNo processes found.\033[0m"
  end
elsif ARGV.includes?("--kill")
  kill_index = ARGV.index("--kill")
  if kill_index.nil? || kill_index + 1 >= ARGV.size
    puts "\033[31mError: You must provide a valid PID to kill a process.\033[0m"
    exit 1
  end

  pid_str = ARGV[kill_index + 1]
  begin
    pid = pid_str.to_i
    if pid > 0
      print "\033[33mAttempting to terminate process #{pid}... \033[0m"
      ProcessInfo.kill_process(pid)
      puts "\033[32m✓ Process terminated!\033[0m"
    else
      puts "\033[31mError: PID must be a positive number.\033[0m"
    end
  rescue
    puts "\033[31mError: '#{pid_str}' is not a valid PID.\033[0m"
  end
end