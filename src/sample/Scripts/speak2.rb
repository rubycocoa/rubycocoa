# Make the computer speak, using the SpeechSynthesis framework.
require 'osx/foundation'
OSX.require_framework '/System/Library/Frameworks/ApplicationServices.framework/Frameworks/SpeechSynthesis.framework'

error, channel =  OSX.NewSpeechChannel(nil)
if error != 0
  $stderr.puts "Can't create new speech channel (error #{error})"
  exit 1
end

unless OSX.SpeakText(channel, 'hello Ruby!') == 0
  $stderr.puts "Can't speak text (error #{error})"
  exit 1
end
sleep 2 # sleeping enough time the computer talks
