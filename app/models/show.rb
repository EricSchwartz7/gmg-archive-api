class Show < ApplicationRecord
    def self.sql_year_string(year)
        "date >= '#{year}-01-01' AND date <= '#{year}-12-31'"
    end
end
