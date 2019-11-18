# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

shows = Show.create([
    {
        venue: "Tir Na Nog",
        date: "08-10-2013",
        first_set: "Carry Me, Chameleon, TMA, Moulder, Boogie Child, The Answer, Mysterious Gloss, Roses, No Quarter",
        second_set: "USSR, Meatstick, San Bliss, Get Lucky, IHYK, Ring of Fire, Sex Machine",
        encore: "Player"
    },
    {
        venue: "Old Bay",
        date: "08-14-2015",
        first_set: "Grove, Moulder, Roses, Gloss, You, Shakedown, Carry Me, Frenkle’s, Words, Sex",
        second_set: "PUTP, On the Rocks, Valerie, TMA, No Quarter, The Answer, San Bliss, IHYK, Jiggy, Player",
        encore: "I Will Survive"        
    }
])