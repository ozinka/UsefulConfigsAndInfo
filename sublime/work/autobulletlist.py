import sublime
import sublime_plugin

class AutoBulletListCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        new_selections = []
        
        for region in self.view.sel():
            line = self.view.line(region)
            line_contents = self.view.substr(line)
            stripped_line = line_contents.strip()
            
            bullet = self.get_bullet(line_contents)
            
            if bullet:
                content_after_bullet = stripped_line[len(bullet):].strip()
                
                if not content_after_bullet:
                    # Only bullet/number (e.g. '• ' or '78. ') -> remove the line and add empty line
                    leading_spaces = line_contents[:len(line_contents) - len(line_contents.lstrip())]
                    
                    # Get the full line including the newline at the end
                    full_line = self.view.full_line(line)
                    line_start = full_line.begin()
                    
                    # Replace the entire bullet/numbered line with leading spaces + two newlines with proper indentation
                    # This creates an empty line and positions cursor on the next line with same indentation
                    self.view.replace(edit, full_line, leading_spaces + "\n" + leading_spaces + "\n")
                    
                    # Position cursor at the end of the second line (after leading spaces)
                    new_selections.append(sublime.Region(line_start + len(leading_spaces) + 1 + len(leading_spaces)))
                    continue
                    
                # Bullet has text -> replace * with •, continue bulleting
                if bullet == "* ":
                    updated_line = line_contents.replace("*", "•", 1)
                    self.view.replace(edit, line, updated_line)
                    bullet = "• "
                
                # For numbered lists, increment the number
                if bullet and bullet[0].isdigit():
                    bullet = self.get_next_numbered_bullet(bullet)
                    
                leading_spaces = line_contents[:len(line_contents) - len(line_contents.lstrip())]
                insert_pos = line.end()
                self.view.insert(edit, insert_pos, "\n" + leading_spaces + bullet)
                new_selections.append(sublime.Region(insert_pos + 1 + len(leading_spaces + bullet)))
            else:
                self.view.run_command("insert", {"characters": "\n"})
                
        if new_selections:
            self.view.sel().clear()
            for sel in new_selections:
                self.view.sel().add(sel)


    def get_bullet(self, line_contents):
        import re

        # Remove leading indentation (not full strip)
        stripped_leading = line_contents.lstrip()

        # Match numbered list like "1. "
        numbered_match = re.match(r'^(\d+)\.\s', stripped_leading)
        if numbered_match:
            return numbered_match.group(1) + '. '

        # Match bullets only if they appear at the beginning (after optional spaces)
        for bullet_char in ("-", "*", "•"):
            if re.match(r'^' + re.escape(bullet_char) + r'\s', stripped_leading):
                return bullet_char + ' '
        return None


    
    def get_next_numbered_bullet(self, bullet):
        """Given a numbered bullet like '78. ', return the next one like '79. '"""
        import re
        match = re.match(r'^(\d+)\. ', bullet)
        if match:
            current_num = int(match.group(1))
            return str(current_num + 1) + ". "
        return bullet