# Create default account's plan 
plans = Plan.create([
  { id: 1, name: 'Individual',  price: 19, users: 1, forms: 5, storage: 100, requests: 500}, 
  { id: 2, name: 'Small Business',  price: 49, users: 3, forms: 10, storage: 1000, requests: 1500}, 
  { id: 3, name: 'Premium Business',  price: 99, users: 5, forms: 20, storage: 5000, requests: 5000}, 
])

# Create system account and user to receive contact message in landing page 
account = Account.create(:company_name => 'System')

user = User.new(
  email: 'system@qm.com', 
  password: 'system@com12', 
  role: 'admin',
  firstname: 'system',
  account_id: account.id,
  lastname: ''
)
user.save(validate: false)

# Create contact form in landing page
form = Form.new(
  name: "Contact Form", 
  fields: {
    "1427095415508"=>{
      "type"=>"email", 
      "description"=>"", 
      "css_class"=>"", 
      "position"=>"0", 
      "label"=>"Email", 
      "placeholder"=>"Enter your email", 
      "validate"=>{"validates_presence_of"=>"1"}
    }, 
    "1427095419321"=>{
      "type"=>"paragraph", 
      "description"=>"", 
      "css_class"=>"", 
      "position"=>"1", 
      "label"=>"Message", 
      "placeholder"=>"Please send us a detailed message", 
      "validate"=>{"validates_presence_of"=>"0"}
    }
  }, 
  account_id: account.id,
  column_style: 1, 
  styles: "", 
  scripts: "", 
  emails: [{"email"=>"daveedchun@gmail.com "}, {"email"=>"sir1001dem@gmail.com"}], 
  ecommerce_type: "ZenCart", 
  thank_msg: "p>Contact form in landing page has submitted</p>\r\n<p>User {{ customer.email }} has sent a message in contact form (landing page)</p>"
)

form.save(validate: false)
