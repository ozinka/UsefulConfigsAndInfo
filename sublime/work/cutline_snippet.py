import datetime
import sublime
import sublime_plugin
import sublime_plugin


def generate_cut_line():
    now = datetime.datetime.now().strftime("%Y.%m.%d %H:%M")
    return "--- ✄ --------- {0} ----------------\n".format(now)

class InsertCutlineAndNewlineCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        line = generate_cut_line()
        for region in self.view.sel():
            pt = region.begin()
            self.view.insert(edit, pt, line)
            # Move cursor to a new line after insertion
            new_cursor = pt + len(line)
            self.view.sel().clear()
            self.view.sel().add(sublime.Region(new_cursor))

class InsertCutlineBelowCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        line = generate_cut_line().rstrip('\n')  # no trailing newline
        for region in self.view.sel():
            pt = region.end()

            # Step 1: insert a newline (like pressing Enter)
            self.view.insert(edit, pt, "\n")
            pt += 1  # move insert point to new line

            # Step 2: insert the cutline
            self.view.insert(edit, pt, line)

            # Step 3: move cursor to start of inserted line
            self.view.sel().clear()
            self.view.sel().add(sublime.Region(pt))

            # Move cursor one line up
            row, col = self.view.rowcol(pt)
            if row > 0:
                new_pt = self.view.text_point(row - 1, col)
                self.view.sel().clear()
                self.view.sel().add(sublime.Region(new_pt))