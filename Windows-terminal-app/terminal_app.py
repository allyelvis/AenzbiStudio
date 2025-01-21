import tkinter as tk
from tkinter import scrolledtext
import subprocess

class TerminalApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Shell Terminal")
        
        self.text_area = scrolledtext.ScrolledText(self, wrap=tk.WORD)
        self.text_area.pack(expand=True, fill='both')
        
        self.entry = tk.Entry(self)
        self.entry.pack(fill='x')
        self.entry.bind("<Return>", self.execute_command)
    
    def execute_command(self, event):
        command = self.entry.get()
        self.entry.delete(0, tk.END)
        
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, error = process.communicate()
        
        self.text_area.insert(tk.END, f"$ {command}\n{output.decode()}\n{error.decode()}\n")
        self.text_area.see(tk.END)

if __name__ == "__main__":
    app = TerminalApp()
    app.mainloop()
