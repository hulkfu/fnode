#!/usr/bin/python
"""
fuzzing app templete
"""

PROGRAM = 'fuzzing'
PLAY_DURATION = 3
MAX_FILESIZE = 1024*1024

from fusil.application import Application
from optparse import OptionGroup
from fusil.process.mangle import MangleProcess
from fusil.process.watch import WatchProcess
from fusil.process.stdout import WatchStdout
from fusil.auto_mangle import AutoMangle
from fusil.terminal_echo import TerminalEcho

class Fuzzer(Application):
    NAME = "fuzzing"
    USAGE = "%prog [options] filename"
    NB_ARGUMENTS = 1

    def createFuzzerOptions(self, parser):
        options = OptionGroup(parser, "fuzzing")
        options.add_option("--fuzzing", help="fuzzing program path (default: %s)" % PROGRAM,
            type="str", default=PROGRAM)
        options.add_option("--duration", help="Playing maximum duration in seconds (default: %s)" % PLAY_DURATION,
            type="int", default=PLAY_DURATION)
        options.add_option("--filesize", help="Maximum file size in bytes (default: %s)" % MAX_FILESIZE,
            type="int", default=MAX_FILESIZE)
        return options

    def setupProject(self):
        project = self.project
        # Command line
        arguments = [self.options.fuzzing]
        timeout = self.options.duration + 1.0

        # Create buggy input file
        orig_filename = self.arguments[0]
        mangle = AutoMangle(project, orig_filename)
        mangle.max_size = self.options.filesize

        process = MangleProcess(project,
            arguments,
            "<fuzzing>",
            timeout=timeout)

        process.setupX11()
        process.env.copy('HOME')
        watch = WatchProcess(process, timeout_score=0)
        if watch.cpu:
            watch.cpu.weight = 0.20
            watch.cpu.max_load = 0.50
            watch.cpu.max_duration = min(3, timeout-0.5)
            watch.cpu.max_score = 0.50

        stdout = WatchStdout(process)

        # Restore terminal state
        TerminalEcho(project)

if __name__ == "__main__":
    Fuzzer().main()
