#!/usr/bin/env ruby
require_relative 'lib/badges'

if ARGV.size != 1
  $stderr.puts "Usage: #{__FILE__} output_pdf_file"
  exit(-1)
end

names = ["Fred Flinstone","Fred Mertz", "Fred Gwynne","Freddie Mac", "Ethel Kennedy","Ethel Mertz", "Ethel Mermen","Ethel Rosenberg"]

badges = Badges::Base.new(:rows=>2, :cols=>4)

names.each do |name|
  badges.add_column do
    text "Sample", :align=>:left
    text "Simple Sample Badge", :align=>:center, :size=>20
    move_down(20)
    whole_size = Badges::Base.right_size(name,badges.bold_font,48,badges.box_width,36)
    if whole_size.nil?
      name_parts = name.split(" ")
      parts_size = Badges::Base.right_size(name_parts,badges.bold_font,48,badges.inset_box_width)
      text name, :size=> parts_size, :style=>:bold, :align=>:center
    else
      text name, :size=> whole_size, :style=>:bold, :align=>:center
    end
    draw_text "Random High School", :at=>[0,15], :size=>18
    draw_text "2011-06", :at=>[0,0], :size=>12
  end
end
badges.render_file(ARGV[0])
