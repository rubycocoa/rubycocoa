require 'osx/cocoa'

snd_files =
  if ARGV.size == 0 then
    `ls /System/Library/Sounds/*.aiff`.split
  else
    ARGV
  end

thr = nil

snd_files.each do |path|
  thr = Thread.start do
    snd = OSX::NSSound.alloc.initWithContentsOfFile_byReference(path, true)
    snd.play
    sleep 1 while snd.isPlaying?
  end
  sleep 0.1
end

thr.join
