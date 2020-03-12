# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@super_admin = User.create(email: 'princerabadiya75@gmail.com',
                           created_at: '2020-02-24 05:55:03',
                           user_name: 'prince_the_admin',
                           first_name: 'prince',
                           last_name: 'rabadiya',
                           gender: 'Male',
                           password: '8140527507420',
                           birth_date: '1999-10-08')

@super_admin.add_role :super_admin
