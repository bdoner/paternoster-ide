
class Screen

    START_ARROWS = { :left => "\u21A4", :up => "\u21A5", :right => "\u21A6", :down => "\u21A7" }
    FLOW_ARROWS = { :left => "\u2190", :up => "\u2191", :right => "\u2192", :down => "\u2193" }
    COND_ARROWS = { :left => "\u21BC", :up => "\u21BF", :right => "\u21C0", :down => "\u21C3" }

    horizontal_line = nil
    vertical_line = nil

    grid = nil
    border = nil
    bg_char = nil
    last_set = nil
    attr_accessor :width, :height
    def initialize width, height
        @width = width
        @height = height
        @grid = Hash.new
        @border = false
        @bg_char = " "
        @horizontal_line = '-'
        @vertical_line = "\u007C"
        @last_set = [0, 0]
    end

    def refresh_status
        cell = @grid[@last_set]
        puts "x: #{cell.x + 1}/#{@width }, y: #{cell.y + 1}/#{@height}, # cells #{@width * @height}"
    end

    def saveable
        outp = ''
        @height.times do |y|
            @width.times do |x|
                if @grid[[x, y]] && @grid[[x, y]].save
                    outp << @grid[[x, y]].val
                else
                    outp << @bg_char
                end
            end
            outp << "\n"
        end
        return outp
    end

    def points_right? val
        case val
            when START_ARROWS[:right], FLOW_ARROWS[:right], COND_ARROWS[:right]
                return true
            else
                return false
        end
    end

    def points_down? val
        case val
            when START_ARROWS[:down], FLOW_ARROWS[:down], COND_ARROWS[:down]
                return true
            else
                return false
        end
    end



    def points_left? val
        case val
            when START_ARROWS[:left], FLOW_ARROWS[:left], COND_ARROWS[:left]
                return true
            else
                return false
        end
    end

    def points_right? val
        case val
            when START_ARROWS[:right], FLOW_ARROWS[:right], COND_ARROWS[:right]
                return true
            else
                return false
        end
    end

    def points_up? val
        case val
            when START_ARROWS[:up], FLOW_ARROWS[:up], COND_ARROWS[:up]
                return true
            else
                return false
        end
    end

    def is_term? val
        case val
            when START_ARROWS[:left], START_ARROWS[:right], START_ARROWS[:up], START_ARROWS[:down],
                    FLOW_ARROWS[:left], FLOW_ARROWS[:right], FLOW_ARROWS[:up], FLOW_ARROWS[:down],
                    COND_ARROWS[:left], COND_ARROWS[:right], COND_ARROWS[:up], COND_ARROWS[:down],
                    'X'
                return true
            else
                return false
        end
    end

    def draw_line x, y
        cell = @grid[[x, y]]
        return if !cell

        #right going lines
        rem_mode = false
        if points_right?(cell.val)
            ((x + 1)..@width).each do |w|
                if @grid[[w, y]] && is_term?(@grid[[w, y]].val)
                    rem_mode = true
                    next
                end
                if rem_mode
                    @grid[[w, y]] = nil if @grid[[w, y]] && @grid[[w, y]].val == @horizontal_line
                    next
                end
                if !@grid[[w, y]]
                    @grid[[w, y]] = Cell.new w, y, @horizontal_line, true, false
                end
            end
        end

        #down going lines
        rem_mode = false
        if points_down?(cell.val)
            ((y + 1)..@height).each do |h|
                if @grid[[x, h]] && is_term?(@grid[[x, h]].val)
                    rem_mode = true
                    next
                end
                if rem_mode
                    @grid[[x, h]] = nil if @grid[[x, h]] && @grid[[x, h]].val == @vertical_line
                    next
                end
                if !@grid[[x, h]]
                    @grid[[x, h]] = Cell.new x, h, @vertical_line, true, false
                end
            end
        end

        #left going lines
        rem_mode = false
        if points_left?(cell.val)
            (x - 1).downto(0).each do |w|
                if @grid[[w, y]] && is_term?(@grid[[w, y]].val)
                    rem_mode = true
                    next
                end
                if rem_mode
                    @grid[[w, y]] = nil if @grid[[w, y]] && @grid[[w, y]].val == @horizontal_line
                    next
                end
                if !@grid[[w, y]]
                    @grid[[w, y]] = Cell.new w, y, @horizontal_line, true, false
                end
            end
        end

        #up going lines
        rem_mode = false
        if points_up?(cell.val)
            (y - 1).downto(0).each do |h|
                if @grid[[x, h]] && is_term?(@grid[[x, h]].val)
                    rem_mode = true
                    next
                end
                if rem_mode
                    @grid[[x, h]] = nil if @grid[[x, h]] && @grid[[x, h]].val == @vertical_line
                    next
                end
                if !@grid[[x, h]]
                    @grid[[x, h]] = Cell.new x, h, @vertical_line, true, false
                end
            end
        end


    end

    def cont
        outp = ''
        if @border
            outp << '+'
            @width.times do |x|
                outp << '-'
            end
            outp << "+\n"
            @height.times do |y|
                outp << '|'
                @width.times do |x|
                    outp << @grid[[x, y]].val if @grid[[x, y]]
                    outp << @bg_char unless @grid[[x, y]]
                    draw_line x, y
                end
                outp << "|\n"
            end
            outp << '+'
            @width.times do |x|
                outp << '-'
            end
            outp << "+\n"
        else
            @height.times do |y|
                @width.times do |x|
                    outp << @grid[[x, y]].val if @grid[[x, y]]
                    outp << @bg_char unless @grid[[x, y]]
                    draw_line x, y
                end
                outp << "\n"
            end
        end
        return outp
    end

    def refresh
        system 'cls'
        outp = cont
        print outp
        refresh_status

    end

    def use_border val
        @border = val
    end

    def set x, y, char, persist = true, save = true
        cell = Cell.new x, y, char, persist, save
        if @grid[[x, y]] == nil || persist || (@grid[[x, y]] != nil && !@grid[[x, y]].persist)
            @grid[[x, y]] = cell
        end
        @last_set = [x, y]
    end

    def unset x, y, force = false
        @grid[[x, y]] = nil if force || (@grid[[x, y]] != nil && !@grid[[x, y]].persist)
    end
end

class Cell
    attr_accessor :x, :y, :val, :persist, :save

    def initialize x, y, val, persist, save
        @x = x
        @y = y
        @val = val
        @persist = persist
        @save = save
    end
end
