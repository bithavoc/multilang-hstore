# -*- coding: utf-8 -*-
$KCODE = "U"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Multilang do
  before :each do
    setup_db
    I18n.locale = :lv
  end

  after :each do
    teardown_db
  end

  it "should test database connection" do
    AbstractPost.create
    AbstractPost.count.should == 1
  end

  it "should add getters/setters in RegularPost" do
    regular_post = RegularPost.new
    %w(title body).each do |attr|
      regular_post.should respond_to(attr)
      regular_post.should respond_to("#{attr}=")
      I18n.available_locales.each do |loc|
        regular_post.should respond_to("#{attr}_#{loc}")
        regular_post.should respond_to("#{attr}_#{loc}=")
      end
    end
  end

  it "should set attributes in RegularPost" do
    rp = RegularPost.new

    # set
    rp.title = "Latviešu nosaukums"
    rp.body = "Latviešu apraksts"
    I18n.locale = :ru
    rp.title = "Русский заголовок"
    rp.body = "Русский текст"
    
    # test
    I18n.locale = :lv
    rp.title.should == "Latviešu nosaukums"
    rp.body.should == "Latviešu apraksts"
    
    I18n.locale = :ru
    rp.title.should == "Русский заголовок"
    rp.body.should == "Русский текст"
  end

  it "should set attributes through alternative setters in RegularPost" do
    rp = RegularPost.new

    # set
    rp.title_lv = "Latviešu nosaukums"
    rp.body_lv = "Latviešu apraksts"
    rp.title_ru = "Русский заголовок"
    rp.body_ru = "Русский текст"
    
    # test
    rp.title_lv.should == "Latviešu nosaukums"
    rp.body_lv.should == "Latviešu apraksts"
    rp.title_ru.should == "Русский заголовок"
    rp.body_ru.should == "Русский текст"

    I18n.locale = :lv
    rp.title.should == "Latviešu nosaukums"
    rp.body.should == "Latviešu apraksts"
    
    I18n.locale = :ru
    rp.title.should == "Русский заголовок"
    rp.body.should == "Русский текст"
  end

  it "should set attributes through fullset hash in RegularPost" do
    rp = RegularPost.new

    # set
    rp.title = {:lv => "Latviešu nosaukums", :ru => "Русский заголовок"}
    rp.body = {:lv => "Latviešu apraksts", :ru => "Русский текст"}
    
    # test
    rp.title_lv.should == "Latviešu nosaukums"
    rp.body_lv.should == "Latviešu apraksts"
    rp.title_ru.should == "Русский заголовок"
    rp.body_ru.should == "Русский текст"
  end

  it "should set attributes through halfset hash in RegularPost" do
    rp = RegularPost.new

    # set
    rp.title = {:lv => "Latviešu nosaukums"}
    rp.body = {:lv => "Latviešu apraksts"}
    
    # test
    rp.title_lv.should == "Latviešu nosaukums"
    rp.body_lv.should == "Latviešu apraksts"
    rp.title_ru.should == ""
    rp.body_ru.should == ""
  end
  
  it "should be validated in RegularPost" do
    rp = RegularPost.new
   
    rp.title = "Latviešu nosaukums"
    rp.body = "Latviešu apraksts"
    I18n.locale = :ru
    rp.title = "Русский заголовок"
    rp.body = "Русский текст"

    rp.should be_valid
  end

  it "should not be validated in RegularPost" do
    rp = RegularPost.new
    
    rp.title_lv = "Latviešu nosaukums"*100  #too long
    rp.body_lv = "" #empty
    rp.title_ru = "" #empty
    rp.body_ru = "Русский текст"*1000 #too long

    rp.valid?
    
    rp.should have(4).errors
  end

  it "should mass assign attributes in RegularPost" do
    rp = RegularPost.new( :title_lv => "Latviešu nosaukums",
                          :title_ru => "Русский заголовок",
                          :body_lv => "Latviešu apraksts",
                          :body_ru => "Русский текст" )
  
    # test
    rp.title_lv.should == "Latviešu nosaukums"
    rp.body_lv.should == "Latviešu apraksts"
    rp.title_ru.should == "Русский заголовок"
    rp.body_ru.should == "Русский текст"
  end

  it "should not mass assign attributes in ProtectedPost" do
    rp = ProtectedPost.new( :title_lv => "Latviešu nosaukums",
                            :title_ru => "Русский заголовок",
                            :body_lv => "Latviešu apraksts",
                            :body_ru => "Русский текст" )
    
    # test
    rp.title_lv.should_not == "Latviešu nosaukums"
    rp.body_lv.should_not == "Latviešu apraksts"
    rp.title_ru.should_not == "Русский заголовок"
    rp.body_ru.should_not == "Русский текст"
  end

  
  it "should mass assign attributes in RegulularPost, v2" do
    rp = RegularPost.new( { :title => {
                              :lv => "Latviešu nosaukums",
                              :ru => "Русский заголовок"
                            },
                            :body => {:lv => "Latviešu apraksts",
                              :ru => "Русский текст"
                            }
                          } )
    
    # test
    rp.title_lv.should == "Latviešu nosaukums"
    rp.body_lv.should == "Latviešu apraksts"
    rp.title_ru.should == "Русский заголовок"
    rp.body_ru.should == "Русский текст"
  end

  it "should not not mass assign attributes in ProtectedPost, v2" do
    rp = ProtectedPost.new( { :title => {
                                :lv => "Latviešu nosaukums",
                                :ru => "Русский заголовок"
                              },
                              :body => {:lv => "Latviešu apraksts",
                                :ru => "Русский текст"
                              }
                            } )
    
    # test
    rp.title_lv.should_not == "Latviešu nosaukums"
    rp.body_lv.should_not == "Latviešu apraksts"
    rp.title_ru.should_not == "Русский заголовок"
    rp.body_ru.should_not == "Русский текст"
  end

  it "should save/load attributes in RegularPost" do
    rp = RegularPost.new( :title_lv => "Latviešu nosaukums",
                          :title_ru => "Русский заголовок",
                          :body_lv => "Latviešu apraksts",
                          :body_ru => "Русский текст" )

    rp.save

    rp = RegularPost.last
    
    rp.title_lv.should == "Latviešu nosaukums"
    rp.body_lv.should == "Latviešu apraksts"
    rp.title_ru.should == "Русский заголовок"
    rp.body_ru.should == "Русский текст"
  end

  it "should save attributes in db as search friendly values" do
    rp = RegularPost.new( :title_lv => "Latviešu nosaukums",
                          :title_ru => "Русский заголовок",
                          :body_lv => "Latviešu apraksts",
                          :body_ru => "Русский текст" )

    rp.save

    rp = RegularPost.last

    rp.title_before_type_cast.should =~ /Latviešu nosaukums/
    rp.title_before_type_cast.should =~ /Русский заголовок/
    rp.body_before_type_cast.mb_chars.should =~ /Latviešu apraksts/
    rp.body_before_type_cast.mb_chars.should =~ /Русский текст/
  end

  it "should return proxied attribute" do
    rp = RegularPost.new( :title_lv => "Latviešu nosaukums",
                          :title_ru => "Русский заголовок",
                          :body_lv => "Latviešu apraksts",
                          :body_ru => "Русский текст" )


    rp.title.should be_an_instance_of(Multilang::MultilangTranslationProxy)
    rp.title.should be_a_kind_of(String)
    
    rp.body.should respond_to(:translation)
    rp.title.translation[:lv].should == "Latviešu nosaukums"
    rp.body.translation[:ru].should == "Русский текст"

    rp.title.to_s.should be_an_instance_of(String)
  end

  # it "should be fast. Maybe. :)" do

  #   t0 = Time.now.to_f
  #   1000.times do 
  #     ap = AbstractPost.new( :title => "Latviešu nosaukums | Русский заголовок",
  #                            :body => "Latviešu apraksts | Русский текст" )
  #     ap.save
  #   end
  #   t1 = Time.now.to_f
  #   1000.times do
  #     rp = MinimalPost.new( :title_lv => "Latviešu nosaukums",
  #                           :title_ru => "Русский заголовок",
  #                           :body_lv => "Latviešu apraksts",
  #                           :body_ru => "Русский текст" )
  #     rp.save
  #   end
  #   t2 = Time.now.to_f

  #   puts "\nTiming:"
  #   puts "AbstractPost without multilang: #{t1 - t0} s."
  #   puts "MinimalPost with multilang: #{t2 - t1} s."

  #   ((t2-t1) / (t1-t0)).should_not be > 4.0
  # end

end
