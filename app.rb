require 'sinatra'
require 'sinatra/reloader'

get '/' do
  'Hello world! welcome'
 
end

get '/htmlfile' do
    send_file 'views/htmlfile.html'
end

get '/htmltag' do
    '<h1>html 태크를 보낼 수 있습니다.</h1>
    <ul>
    <li>1</li>
    <li>22</li>
    <li>333</li>
    </u>'
end

get '/welcome/:name' do
"#{params[:name]}님 안녕하세요"
end

get '/cube/:num' do
    
    input = params[:num].to_i
    result = input ** 3
    "<h1>#{result}</h1>"
    
end

get '/erbfile' do
    @name = "Seon"
    erb :erbfile
end

get '/lunch' do
    # 메뉴들을 배열에 저장한다.
    menu = ["20층","김밥카페","시골집","시래기"]
    # 하나를 추천한다.
    @result = menu.sample
    # erb 파일에 담아서 보낸다
    erb :lunch
   
end

get '/lunch-hash' do
 # 메뉴들이 저장된 배열을 만든다
 menu = ["짜장면","탕수육","짬뽕","깐풍기"]
 # 메뉴 이름(key) 사진url(value)를 가진 Hash를 만든다.
hash = { "짜장면" => "http://ojsfile.ohmynews.com/STD_IMG_FILE/2016/1214/IE002069160_STD.jpg",
"짬뽕" => "http://college.koreadaily.com/wp-content/uploads/2016/09/champon.jpg",
"탕수육" => "https://homecuisine.co.kr/files/attach/images/142/737/002/969e9f7dc60d42510c5c0353a58ba701.JPG",
"깐풍기" => "http://www.fsnews.co.kr/news/photo/201105/4416_3190_2746.jpg"
}
 # 랜덤으로 하나를 출력한다.
 @menu_result=menu.sample
 @menu_img = hash [@menu_result]
 # 이름을  url로 남겨서 erb로 가져온다.
 erb :lunchhash
end

get '/randomgame/:name' do
    @name = params[:name]
    img = ["즐거움","슬픔","행복","화남"]
    img_hash={ "즐거움" => "http://file3.instiz.net/data/file3/2018/01/30/0/8/9/089aaddd95d4e3f6d26298edef0502b5.gif",
    "슬픔" => "http://jjalbox.com/_data/jjalbox/2018/01/20180125_5a696c212fbd2.gif",
    "행복" => "http://file.instiz.net/data/file/20140703/a/6/b/a6b9c40d2b2e384b952e91ce0914794c.gif",
    "화남" => "http://jjalbox.com/_data/jjalbox/2017/12/20171221_5a3a854542aab.gif"    
    }
   
    @img_result = img.sample
    @img= img_hash[@img_result]
    erb :randomgame
end

