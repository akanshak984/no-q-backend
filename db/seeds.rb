# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Category.destroy_all
Category.insert_all(
  [
    {
      name: 'Groceries',
      code: 'GRO'
    },
    {
      name: 'Medical',
      code: 'MED'
    },
    {
      name: 'Liquor',
      code: 'LIQ'
    },
    {
      name: 'Clothing',
      code: 'CLO'
    },
    {
      name: 'Vegitables/Fruits',
      code: 'VEG/FRU'
    },
    {
      name: 'Electronics',
      code: 'ELEC'
    }
  ]
)

Item.insert_all(
  [
    {
      name: 'rice',
      price: 20
    },
    {
      name: 'toothpaste',
      price: 80
    },
    {
      name: 'sanitizer',
      price: 120
    },
    {
      name: 'salt',
      price: 14
    },
    {
      name: 'dal',
      price: 50
    },
    {
      name: 'wheat',
      price: 120
    }
  ]
)
