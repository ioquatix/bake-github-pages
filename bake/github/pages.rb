# frozen_string_literal: true

# Copyright, 2021, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'build/files'

require 'bake/github/pages/shell'
include Bake::GitHub::Pages::Shell

def prepare(branch: "pages", directory: "pages")
	root = Build::Files::Path.current
	worktree = root + directory
	
	system("git", "worktree", "add", "--detach", "--no-checkout", worktree.to_s)
	
	begin
		# Ensure we have the latest branch from origin:
		system("git", "fetch", "origin", branch)
	rescue
		# Ignore.
	end
	
	begin
		# Try checking out the remote branch if it exists:
		system("git", "checkout", branch, chdir: worktree)
	rescue
		# Otherwise check out an orphan branch...
		system("git", "checkout", "--orphan", branch, chdir: worktree)
		system("git", "rm", "-rf", ".", chdir: worktree)
	end
end

AUTHOR = {
	"EMAIL" => "<>",
	"GIT_AUTHOR_NAME" => "Bake GitHub Pages Automation",
	"GIT_COMMITTER_NAME" => "Bake GitHub Pages Automation",
}

def commit(branch: "pages", directory: "pages", message: "Update GitHub Pages.")
	root = Build::Files::Path.current
	worktree = root + directory
	
	unless clean?(worktree)
		system("git", "add", "-A", chdir: worktree)
		
		system(AUTHOR, "git", "commit", "-m", message, chdir: worktree)
		system("git", "push", "--set-upstream", "origin", branch, chdir: worktree)
	end
end

private

def clean?(directory)
	lines = readlines("git", "status", "--porcelain", chdir: directory)
	
	return lines.empty?
end
