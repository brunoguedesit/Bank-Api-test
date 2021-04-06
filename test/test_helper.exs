ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
File.mkdir_p(Path.dirname(JUnitFormatter.get_report_file_path()))
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(StoneBank.Repo, :manual)
