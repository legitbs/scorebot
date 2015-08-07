require 'open3'
class ShellProcess
  def initialize(directory, *args)
    @directory = directory
    @args = args.map(&:to_s)
  end

  def success?
    guard_run
    @status.success?
  end

  def output
    guard_run
    @output
  end

  def status
    guard_run
    @status
  end

  private
  def guard_run
    has_run? || run
  end

  def has_run?
    @status || false
  end

  def run
    return if has_run?

    Scorebot.log "running #{@args.join ' '}"

    @output = ''

    cmd = "./#{@args.join ' '}"

    Dir.chdir @directory do
      IO.popen cmd, 'r', err: %i{child out} do |stdout|
        @output << stdout.read
      end
    end

    @status = $?
  end
end
