require 'nokogiri'
require 'colorize'
require 'httparty'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

@url = "https://funkysouls.org/"

def parse_the_page(url)

html = HTTParty.get(url)
parsed = Nokogiri::HTML.parse(html)

@doc = parsed.css('h2>a')

end

def sort_for_list(parsed_document)

@doc.each do |s|
	if (s.values[1].include?("[2021]") || s.values[1].include?("[2020]"))
		puts s.values
		@split_them_up = s.values[1].gsub(/[\u2013]/,'-').encode('ASCII', invalid: :replace, undef: :replace, replace: "").split(' - ')
		puts @split_them_up
		@split_them_up[1].gsub!('[2021]', '')
		@split_them_up[1].gsub!('[2020]', '')
		@split_them_up[1].strip!
		carve_in_rock(s.values[0], @split_them_up[0], @split_them_up[1])
		puts s.values[0], @split_them_up[0], @split_them_up[1].green
	else
		puts "Nothing Here Folks".red
	end
end
end

def carve_in_rock(link, artist, title)
File.open("list.txt", "a") {|f| f.write(link + "," + artist + "," + title + "\n") }
end

def next_phase()

for i in 2..30
	
	@url = "https://funkysouls.org/page/#{i}.html"
	parse_the_page(@url)
	sort_for_list(@doc)
next i
end
end

parse_the_page(@url)
sort_for_list(@doc)
next_phase()