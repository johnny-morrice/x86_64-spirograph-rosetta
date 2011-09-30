# This is a little tool helpful when debugging.
# Both the C and Assembler versions should log the same output

def nums f
    ls = f.split "\n"
    ls.map {|l| l.to_f}
end

cf = File.read "c/log"
asmf = File.read "asm/log"

cs = nums cf
asms = nums asmf

puts "Logs match? #{cs == asms}"
