require 'io/console'

terminal_width = IO.console.winsize[1]

def to_emoji(str)
  # 任意のアルファベットをSlack絵文字にする
  str.split("").map{|char| ":alphabet-white-#{char}:"}.join("")
end

shuffled_chars = "yasunori".split("").shuffle.join("")
emojis = to_emoji(shuffled_chars)

puts emojis

if shuffled_chars == "yasunori" then
  msgs = ["========================================  Your jackpod!! ========================================",
   "Let's delete your PC'S Operating System!",
   "dd if=iso_path of=/dev/your_device bs=4M"]

  msgs.map {|msg| puts msg.center(terminal_width)}
end
