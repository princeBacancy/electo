@super_admin = User.new(
  email: 'princerabadiya75@gmail.com',
  user_name: 'prince_the_admin',
  first_name: 'prince',
  last_name: 'rabadiya',
  gender: 'Male',
  password: 'Super!admin420',
  password_confirmation: 'Super!admin420',
  birth_date: '1999-10-08'
)
@super_admin.save!
@super_admin.add_role :super_admin
