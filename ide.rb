require 'io/console'
load 'screen.rb'

'''
== START ARROWS ==
↤ ↥ ↦ ↧

== NORMAL ARROWS ==
← ↑  → ↓
↖ ↗ ↘ ↙

== CONDITIONAL ARROWS ==
↿ ⇃ ↼ ⇀
'''

def get_second type
    print " < conditional arrow > " if type == 'i'
    print " < flow arrow > " if type == 'f'
    print " < entry arrow > " if type == 'e'
    return STDIN.getch
end

screen = Screen.new 50, 30
screen.use_border true

x, y = 0, 0
while 1
    screen.set x, y, '+', false, false
    screen.refresh

    cmd = STDIN.getch

    case cmd
        #navigation
        when 'h'
            screen.unset x, y
            x -= 1 if x > 0
        when 'j'
            screen.unset x, y
            y += 1 if y < screen.height - 1
        when 'k'
            screen.unset x, y
            y -= 1 if y > 0
        when 'l'
            screen.unset x, y
            x += 1 if x < screen.width - 1
        when 'i' # conditional
            cmd_2 = get_second cmd
            case cmd_2
                #controls
                when 'h'
                    screen.set x, y, Screen::COND_ARROWS[:left]
                when 'j'
                    screen.set x, y, Screen::COND_ARROWS[:down]
                when 'k'
                    screen.set x, y, Screen::COND_ARROWS[:up]
                when 'l'
                    screen.set x, y, Screen::COND_ARROWS[:right]
                else
                    #pass
            end
        when 'e' #entry
            cmd_2 = get_second cmd
            case cmd_2
                #controls
                when 'h'
                    screen.set x, y, Screen::START_ARROWS[:left]
                when 'j'
                    screen.set x, y, Screen::START_ARROWS[:down]
                when 'k'
                    screen.set x, y, Screen::START_ARROWS[:up]
                when 'l'
                    screen.set x, y, Screen::START_ARROWS[:right]
                else
                    #pass
            end
        when 'f' #flow
            cmd_2 = get_second cmd
            case cmd_2
                #controls
                when 'h'
                    screen.set x, y, Screen::FLOW_ARROWS[:left]
                when 'j'
                    screen.set x, y, Screen::FLOW_ARROWS[:down]
                when 'k'
                    screen.set x, y, Screen::FLOW_ARROWS[:up]
                when 'l'
                    screen.set x, y, Screen::FLOW_ARROWS[:right]
                else
                    #pass
            end

        #misc
        when 'c'
            screen.unset x, y, true
        when 'x', 'X'
            screen.set x, y, 'X'
        when 'a', 'A'
            screen.set x, y, 'A'
        when 'p', 'P', '?', '=', '|', '<', '>', '!', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
            screen.set x, y, cmd
        when 's'
            print " < input > "
            str = gets.chomp
            str = '"' + str + '"'
            str.each_char do |c|
                screen.set x, y, c
                x += 1
            end
        when 'v'
            print " < input > "
            str = gets.chomp
            str = '$' + str
            str.each_char do |c|
                screen.set x, y, c
                x += 1
            end
        when 'b'
            print " < input > "
            str = gets.chomp
            str = str + '$'
            str.each_char do |c|
                screen.set x, y, c
                x += 1
            end
        when 'o'
            print " < out file > "
            str = gets.chomp

            if File.exists?(str)
                puts "Can't overwrite existing files"
                next
            end

            cont = screen.saveable
            File.open(str, 'w') do |f|
                f.write cont
            end
            puts "wrote file to #{str}"
            sleep 3
        when 'q'
            break
        else
            #pass
    end
end
