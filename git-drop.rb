#!/usr/bin/env ruby

## git-drop
## USAGE: git drop [-n] [-f] [...pathspec]
## Runs git checkout -- pathspec but behaves like git clean; will list files it wants to change
## with -n and will run checkout on them with -f
## If no pathspec specified, assumes current directory

dry_run = false
force = false
pathspec = []

ARGV.each do |value|
  dry_run = dry_run || (value == '-n')
  force = force || (value == '-f')
  if (value != '-n' && value != '-f')
    pathspec.push value
  end
end


if !dry_run && !force
  puts 'fatal: drop requires force and neither -n nor -f given; refusing to drop changes'
  return
end

pathspec.each do |path|
  if !((Dir.exist? path) || (File.exists? path))
    puts "fatal: not a file or directory: #{path}"
    return
  end
end

if pathspec.empty?
  pathspec.push '.'
end

files_to_change = `git ls-files -dm -- #{pathspec.join(' ')}`
return unless $?.success?

if files_to_change.empty?
  puts 'No modifications found in specified files, working tree clean'
elsif dry_run
  puts 'Would drop modifications and reset to index on the following files:'
  puts files_to_change
elsif force
  puts 'Dropping modifications on the following files:'
  puts files_to_change
  `git checkout -- #{pathspec.join(' ')}`
end
