require 'rails_helper'

feature 'Subscriber create a good' do
  let(:qs) { "appid=#{Rails.application.secrets.wechat_app_id}&secret=#{Rails.application.secrets.wechat_app_secret}&code=CODE&grant_type=authorization_code" }
  let(:user) { create(:a_subscriber) }

  before(:each) do
    stub_request(:get, "https://api.weixin.qq.com/sns/oauth2/access_token?#{qs}").
      to_return(
        :body => {:access_token => 'ACCESS_TOKEN',
                          :expires_in => 7200,
                          :refresh_token => "REFRESH_TOKEN",
                          :openid => user.weixin,
                          :scope => "snsapi_base"
        }.to_json,
        :status => 200,
        :headers => {'Content-Type' => 'application/json'})

    stub_request(:get, "https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN").
      to_return(
        :body => {
          openid: user.weixin,
          nickname: 'mcknight0219',
          sex: 1,
          headimage: "https://upload.wikimedia.org/wikipedia/commons/0/07/Avatar_girl_face.png"
       }.to_json,
        :status => 200,
        :headers => {'Content-Type' => 'application/json'})
  end

  scenario 'with valid input' do
    visit '/gate/index?redirectTo=goods/new&code=CODE'    
    fill_and_submit_good_form

    expect(page).to have_content '请选择或新增邮寄方式'
  end

  scenario 'See no express method available' do
    visit 'gate/index?redirectTo=goods/new&code=CODE'    
    fill_and_submit_good_form

    see_no_express_method_available
    # Add a new express method
    click_on('添加') 
    fill_and_submit_express_method_form
    
    expect(page).to have_content('shuntong')
    
    fill_and_submit_express_select_form
    expect(page).to have_content('Success')

    check_express_method
    check_good
    check_relations

    click_on('Add another product')
    expect(page).to have_content('请上传你的第一个商品吧')
  end

  def see_no_express_method_available
    expect(page).to_not have_content('shuntong')
  end

  def check_express_method
    expect(ExpressMethod.count).to eq 1
    expect(ExpressMethod.first.company).to eq 'shuntong'
    expect(ExpressMethod.first.rate).to eq 2.99
  end


  def check_good
    expect(Good.count).to eq 1
    expect(Good.first.brand).to eq 'coach'
    expect(Good.first.price).to eq 100.99
  end


  def check_relations
    expect(Good.first.express_method.id).to eq ExpressMethod.first.id
    expect(user.express_methods.count).to eq 1
    expect(user.goods.count).to eq 1
  end

  def fill_and_submit_good_form 
    fill_in 'name',   with: 'bag'
    fill_in 'brand',  with: 'coach'
    select  'CAD',    from: 'currency'
    fill_in 'price',  with: 100.99
    fill_in 'description', with: 'a fantastic women purse'
    click_button '继续'
  end

  def fill_and_submit_express_method_form 
    fill_in 'company',  with: 'shuntong'
    select '加拿大',    from: 'country'
    select '磅',        from: 'unit'
    fill_in 'rate',     with: 2.99   
    select '一个星期之内', from: 'duration'
    fill_in 'description', with: 'nothing'

    click_on('添加')
  end

  def fill_and_submit_express_select_form
    choose 'shuntong'
    check 'publish'
    click_button '发布'
  end

end


