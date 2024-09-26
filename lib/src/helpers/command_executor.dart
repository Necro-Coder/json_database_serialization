import 'dart:io';

class CommandExecutor {
  Future<String> execute(String command) async {
    List<String> args = command.split(' ');
    String executable = args.removeAt(0);

    try {
      ProcessResult result = await Process.run(executable, args);

      if (result.exitCode == 0) {
        return result.stdout;
      } else {
        throw Exception('Error: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('Failed to run command: $e');
    }
  }
}