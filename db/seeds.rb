@super_admin = User.create_with(
  user_name: 'prince_the_admin',
  first_name: 'prince',
  last_name: 'rabadiya',
  gender: 'Male',
  password: '8140527507420',
  birth_date: '1999-10-08'
).find_or_create_by(email: 'princerabadiya75@gmail.com')

@super_admin.add_role :super_admin