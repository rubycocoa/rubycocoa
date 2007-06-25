# Build the libffi.a library if needed.
unless ['/usr/lib/libffi.a', '/usr/local/lib/libffi.a'].any? { |p| File.exist?(p) }
    Dir.chdir('./misc/libffi') { command('make -f Makefile.rubycocoa') }
end
