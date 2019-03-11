
require 'pry'
class MusicLibraryController

   def initialize(path = "./db/mp3s")
    MusicImporter.new(path).import
  end

   def call
    input = ""
    until input == "exit"
      puts "Welcome to your music library!"
      puts "To list all of your songs, enter 'list songs'."
      puts "To list all of the artists in your library, enter 'list artists'."
      puts "To list all of the genres in your library, enter 'list genres'."
      puts "To list all of the songs by a particular artist, enter 'list artist'."
      puts "To list all of the songs of a particular genre, enter 'list genre'."
      puts "To play a song, enter 'play song'."
      puts "To quit, type 'exit'."
      puts "What would you like to do?"
      input = gets.chomp
      case input
      when "list songs"
        list_songs
      when "list artists"
        list_artists
      when "list genres"
        list_genres
      when "play song"
        play_song
      when "list artist"
        list_artist
      when "list genre"
        list_genre
      when "exit"
        puts "Goodbye"
      else
        puts "invalid action"
      end
    end
  end

  def library(klass = Song)
      sorted_library = klass.all.collect{|object|object if object.class == klass }
      sorted_library = sorted_library.delete_if {|object|object==nil}
      sorted_library.uniq
    end

   def list_songs
    #  binding.pry
    # Song.all.each_with_index {|song,index|puts "#{index+1}. #{song.artist.name} - #{song.name} - #{song.genre.name}"}
    sorted_library = self.library.sort_by {|song|song.name}
    sorted_library.each do |song|
      puts "#{sorted_library.index(song) + 1}. #{song.artist.name} - #{song.name} - #{song.genre.name}"
    end
  end

  #  def list_artists
  #   #  binding.pry
  #   Artist.all.each {|artist| puts artist.name}
  # end

  def list_artists
      sorted_library = self.library(Artist).sort_by {|object|object.name}
      artists = sorted_library.collect {|object|"#{object.name}"}.uniq
      artists.each {|artist| puts "#{artists.index(artist) + 1}. #{artist}"}
    end

  #  def list_genres
  #   Genre.all.each {|genre| puts genre.name}
  # end

  def list_genres
    sorted_library = self.library.sort_by {|song|song.genre.name}
    genres = sorted_library.collect {|song|"#{song.genre.name}"}.uniq
    genres.each {|genre| puts "#{genres.index(genre) + 1}. #{genre}"}
  end

   def play_song
    song = Song.all[gets.to_i - 1]
    puts "Playing #{song.artist.name} - #{song.name} - #{song.genre.name}"
  end

   def list_artist
    puts "Enter artist"
    specific_artist = gets.chomp
    if Artist.find_by_name(specific_artist) != nil
      Artist.find_by_name(specific_artist).songs.each {|song| puts "#{song.artist.name} - #{song.name} - #{song.genre.name}"}
    else
      puts "Artist does not exist"
    end
  end

   def list_genre
    puts "Enter genre"
    specific_genre = gets.chomp
    if Genre.find_by_name(specific_genre) != nil
      Genre.find_by_name(specific_genre).songs.each {|song| puts "#{song.artist.name} - #{song.name} - #{song.genre.name}"}
    else
      puts "Genre does not exist"
    end
  end

 end
