require 'nokogiri'
require 'colorize'
require 'httparty'
require 'pry'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

@funkysouls_url = "https://funkysouls.org/"
@album_of_the_year_url = "https://www.albumoftheyear.org/releases/this-week/"
@artistArray = []
@albumArray = []
@mashem = []

def parse_the_page(url)

html = HTTParty.get(url)
parsed = Nokogiri::HTML.parse(html)

	if url == @funkysouls_url || url.include?('funkysouls')
	
		doc = parsed.css('h2>a')
		
		sort_for_list_funkysouls(doc)
		
	elsif url == @album_of_the_year_url || url.include?('albumboftheyear')
	
		#@doc = parsed.css('div>div>div>a>div') #Returns an array where the first one is the Artist Title and the second is the AlbumTitle.
		doc = parsed.css('div>div>div>a>div')
		
		sort_for_list_album_of_the_year(doc)


	end

end


def sort_for_list_funkysouls(parsed_document)
@artistArray, @albumArray = [], []

parsed_document.each do |s|
	if (s.values[1].include?("[2021]") || s.values[1].include?("[2020]"))
		
		@split_them_up = s.values[1].gsub(/[\u2013]/,'-').encode('ASCII', invalid: :replace, undef: :replace, replace: "").split(' - ')
		
		puts @split_them_up
				
		@split_them_up[1].gsub!('[2021]', '')
		@split_them_up[1].gsub!('[2020]', '')
		@split_them_up[1].strip!
		
		@artistArray << @split_them_up[0]
		@albumArray << @split_them_up[1]
		
		mashem = @artistArray.zip(@albumArray)
#		mashem.reject{|s| s.empty? }

		
		@mashem = @mashem + mashem
		
				
		#carve_in_rock(s.values[0], @split_them_up[0], @split_them_up[1])
		puts s.values[0], @split_them_up[0], @split_them_up[1].green
	else
		puts "Nothing Here Folks".red
	end
end
end


def next_phase_funkysouls()

for i in 2..5
	
	url = "https://funkysouls.org/page/#{i}.html"
	parse_the_page(url)
	
	next i
	
end

end


def sort_for_list_album_of_the_year(parsed_document)

@artistArray, @albumArray = [], []

	parsed_document.each do |aa|
		puts aa.values.to_s
		if aa.values.include?("artistTitle") == true
			@artistArray << aa.text.to_s
		elsif aa.values.include?("albumTitle") == true
			@albumArray << aa.text.to_s
		end
	end
	
	mashem = @artistArray.zip(@albumArray)
	
#	mashem.reject{|s| s.empty? }

	
	@mashem = @mashem + mashem
#	mashem.each do |t|
#		carve_in_rock("AlbumOfTheYear", t[0], t[1])
#	end
	
end

def single_them_out(monster_mash)

puts "Number before Uniqueness: #{monster_mash.count}"

monster_mash.uniq!

puts "Number after Uniqueness: #{monster_mash.count}"

			

puts "Number after empty removals: #{monster_mash.count}"

	monster_mash.each do |dance|
	
		carve_in_rock("null", dance[0], dance[1])
	
	end

end


def carve_in_rock(data, artist, title)

File.open("list.txt", "a") {|f| f.write(artist + ",,," + title + "\n") }

end

parse_the_page(@funkysouls_url)
next_phase_funkysouls()

parse_the_page(@album_of_the_year_url)

single_them_out(@mashem)




#https://www.officialcharts.com/new-releases/
#https://www.allmusic.com/newreleases
#https://www.metacritic.com/browse/albums/release-date/new-releases/date
