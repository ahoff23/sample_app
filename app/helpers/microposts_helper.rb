module MicropostsHelper

	def wrap(content)
		#Split the string into seperate words (based on spaces)
		#Create a new array of all of the new strings created by splitting 30+
		#character words into multiple words with zero width spaces between them
		#Then rejoin the words in a string with spaces in between array elements
		#Clean the data with sanitize() and raw()
		sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
	end

	private

	#Text and max_width as parameters, with default width set to 30
	def wrap_long_string(text, max_width = 30)
		#Define a zero width space string with the proper HTML encoding
		zero_width_space = "&#8203;"
		#Regex expression for any single character. Limited to a range of 1 to max_width
		regex = /.{1,#{max_width}}/
		#If the text length is less than the max_width, just return the text
		#Otherwise, scan using the regex (i.e. split based on regex definition and join with zero_width_space)
		(text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
	end
end
