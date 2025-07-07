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
                # Replace * with • BEFORE checking content
                if bullet == "* ":
                    updated_line = line_contents.replace("*", "•", 1)
                    self.view.replace(edit, line, updated_line)
                    bullet = "• "
                    # Update line_contents after replacement
                    line_contents = updated_line
                    stripped_line = line_contents.strip()
                
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
                
                # For numbered lists, increment the number
                if bullet and bullet[0].isdigit():
                    bullet = self.get_next_numbered_bullet(bullet)
                    
                leading_spaces = line_contents[:len(line_contents) - len(line_contents.lstrip())]
                
                # *** ГОЛОВНА ЗМІНА: визначаємо позицію курсора відносно початку рядка ***
                cursor_pos = region.begin() - line.begin()
                
                # Розділяємо текст на частини до та після курсора
                text_before_cursor = line_contents[:cursor_pos]
                text_after_cursor = line_contents[cursor_pos:]
                
                # Замінюємо весь рядок на текст до курсора
                self.view.replace(edit, line, text_before_cursor)
                
                # Вставляємо новий рядок з bullet та текстом після курсора
                insert_pos = line.begin() + len(text_before_cursor)
                new_line_content = "\n" + leading_spaces + bullet + text_after_cursor
                self.view.insert(edit, insert_pos, new_line_content)
                
                # Позиціонуємо курсор після bullet на новому рядку
                new_cursor_pos = insert_pos + 1 + len(leading_spaces + bullet)
                new_selections.append(sublime.Region(new_cursor_pos))
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