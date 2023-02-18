class Song < ApplicationRecord
  has_many :show_songs
  has_many :shows, through: :show_songs
  has_many :media_items, through: :media_item_songs

  ### Instance methods ###

  def set_appearance_shows(set_number)
      ShowSong.where({song_id: id, set: set_number}).map{ |show_song| show_song.show }
  end
  
  def set_closer_shows(set_number)
      set_appearance_shows(set_number).select do |show|
          show.get_single_set(set_number).last.id == id
      end.count
  end

  ### Class methods ###

  def self.calculate_stat(stat)
      if (stat == "percentage_played") || (stat.ends_with? "closers")
          run_calculation(stat)
      else
          format_stat_array(run_calculation(stat))
      end
  end

  def self.run_calculation(stat)
      case stat
      when "times_played"
          times_played
      when "percentage_played"
          percentage_played
      when "first_set_openers"
          set_openers(1)
      when "second_set_openers"
          set_openers(2)
      when "first_set_closers"
          set_closers(1)
      when "second_set_closers"
          set_closers(2)
      when "encore_appearances"
          encore_appearances
      end
  end

  def self.format_stat_array(stat_hash)
      stat_hash.map do |key, value|
          {
              id: key[0],
              title: key[1],
              value: value
          }
      end
  end

  def self.times_played
      Song.joins(:show_songs)
          .group(:song_id, :title)
          .order("count_all desc")
          .count
  end

  def self.percentage_played
      show_count = Show.count
      times_played.map do |key, value|
          {
              id: key[0],
              title: key[1],
              value: ((value.to_f / show_count) * 100).round(1)
          }
      end
  end

  def self.set_openers(set_number)
      Song.joins(:show_songs)
          .where(show_songs: { set: set_number, position: 0 })
          .group(:song_id, :title)
          .order("count_all desc")
          .count
  end

  def self.encore_appearances
      Song.joins(:show_songs)
          .where(show_songs: { set: 3 })
          .group(:song_id, :title)
          .order("count_all desc")
          .count
  end

  def self.set_closers(set_number)
      song_list = all.map do |song|
          {
              id: song.id,
              title: song.title,
              value: song.set_closer_shows(set_number)
          }
      end
      song_list
          .select{ |song| song[:value] > 0 }
          .sort_by{ |song| -song[:value] }
  end

end
