#!/usr/bin/env ruby
require 'rubygems'
require 'prawn'
require 'prawn/layout'
require 'prawn/table'

module Badges
  class Base
    attr_accessor :bold_font,:box_width
    
    def inset_box_width
      @box_width-@margin*2
    end
    
    def initialize(options={})
      raise ArgumentmentError unless options.is_a? Hash
      default_options = {:cols => 4, :rows => 2, :page_size => 'LETTER', :margin=>10, :page_layout=>:landscape}
      filled_options = default_options.merge(options)
      @cols = filled_options[:cols] || 4
      @rows = filled_options[:rows] || 2
      @doc = Prawn::Document.new(filled_options)
      @bold_font = @doc.font "Helvetica", :size => 48, :style => :bold
      @normal_font = @doc.font "Helvetica", :size => 48
      @box_width = @doc.margin_box.width / @cols
      @box_height = @doc.margin_box.height / @rows
      @row,@col=nil,nil
      @margin=filled_options[:margin]
    end

    def add_column(&block)
      increment_position
      @doc.stroke do
        pos = [@col*@box_width,(@row+1)*@box_height]
        @doc.rectangle(pos,@box_width,@box_height)
        pos = [pos[0]+@margin, pos[1]-@margin]
        new_width = (@box_width-(@margin*2))
        new_height = (@box_height-(@margin*2))
        @doc.bounding_box(pos, :width=>new_width, :height=>new_height) do
          @doc.instance_eval(&block)
        end
      end
    end

    def render_file(filename)
      @doc.render_file(filename)
    end

    private
    def increment_position
      if @col.nil?
        @col=0
        @row=0
      else
        @col+=1
      end
      if @col >= @cols
        @row +=1
        @col = 0
      end
      if @row >= @rows
        @doc.start_new_page
        @row=0
        @col=0
      end
      #$stderr.puts "rows: #{@row}  cols: #{@col}"
    end
    
    def self.right_size(s,font,font_size,max_width,min_font=16)
      if s.is_a? Array
        return s.collect{|st| i = right_size(st,font,font_size,max_width,min_font); i.nil? ? 0 : i}.min
      else
        too_big=true
        return_size = font_size
        font_size.downto(min_font) do |x|
          string_width = font.compute_width_of(s, :size => x)
          #$stderr.puts string_width
          if string_width + 0 <= max_width
            too_big=false
            return_size = x
            break
          end
        end
        if too_big
          return nil
        else
          return return_size
        end
      end
    end
  end
end
