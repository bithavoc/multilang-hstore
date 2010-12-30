ActiveRecord::Schema.define(:version => 1) do
  create_table :abstract_posts do |t|
    t.text :title
    t.text :body
    t.integer :void, :default => 1
  end

  #create_table :posts do |t|
  #  t.text :title
  #  t.text :body
  #  t.integer :void, :default => 1
  #end

  #create_table :pages do |t|
  #  t.text :title
  #  t.text :body
  #  t.integer :void, :default => 1
  #end
end
