module Winner
    def self.banav
        @winner = Winner.create!(election_id: 4, election_datum_id: 3)
    end
end