require 'sinatra'
# sinatra 사용
require 'sinatra/reloader'
# sinatra 수정시 서버 재시작하게 하는것
require 'rest-client'
# url 받는데 사용  터미널에서 gem install rest-client
# gem 설치시 또는 라우팅 재설정 시  서버재시작 필요
require 'json'
require 'httparty'
require 'nokogiri'
require 'uri'
require 'date'
require 'csv'

before do 
    p "*****************"
    p params
    p "*****************"
end

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

get '/lotto-sample' do
   @lotto = (1..45).to_a.sample(6).sort
   url = "http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
   # Chrome 확장 프로그램 JSON View 받아서 접속하면 구분되서 보기 편함
   @lotto_info = RestClient.get(url)
   @lotto_hash=JSON.parse(@lotto_info)
   
   @winner =[]
   @lotto_hash.each do |k, v|
       if k.include?('drwtNo') 
        #배열에 저장
        @winner << v
       end
   end
   # 몇개가 일치하는지 확인
   @matchnum=(@winner & @lotto).length
  
   # 몇등인지 구분
   @bonusnum =[@lotto_hash["bnusNo"]]
    
    bonusmatch= @bonusnum & @lotto
    
    #로또 당첨번호에 보너스번호가 있는지 확인 결과값  boolean
    # 대상.include(확인할 값)으로 확인
    
    @result="꽝"
    
    if (@matchnum == 3) then @result = "5등"
        elsif @matchnum == 4 then @result = "4등"
            elsif @matchnum == 5 then @result = "3등"
            elsif @matchnum == 5 and bonusmatch==1 then  @result = "2등"
            elsif @matchnum == 6 then @result = "1등"
            else  @result="꽝"
    end
    
    # #case문
    # @result=
    # case [@matchnum, @lotto.include(@lotto_hash["bnusNo"])]
    # when [6,false] then "1등"
    # when [5,true] then "2등"
    # when [5,false] then "3등"
    # when [4,false] then "4등"
    # when [3,false] then "5등"
    # else '꽝'

   erb :lottosample
end

get '/form' do
erb :form
end

get '/search' do
    @keyword = params[:keyword]
    @encodeKeyword=URI.encode(@keyword)
    url = 'https://search.naver.com/search.naver?query='
    # erb :search
    redirect to (url+@encodeKeyword)
end


get '/opgg' do
erb :opgg

end

get '/opggresult' do
    url = 'http://www.op.gg/summoner/userName='
    @userName = params[:userName]
    @encodeName=URI.encode(@userName)
    
    @res = HTTParty.get(url+@encodeName)
    #HTML코드에서 바디안에만 검색
    @doc = Nokogiri::HTML(@res.body)
    #구글에서 개발자모드(F12로 해서 원하는 부분 클릭 후  검사 -> copy->selector로 복사)
    @win = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins")
    @lose = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses")
    @rank = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierRank > span")
    
    # File.open(파일이름, 옵션) do |f|
    # 옵션 참고 정보 https://stackoverflow.com/questions/3682359/what-are-the-ruby-file-open-modes-and-options
    #텍스트에 저장함
    # File.open("opgg.txt", 'a+') do |f|
    #     f.write("#{@userName} : #{@win},#{@lose},#{@rank}\n" )
    # end
    
    #CSV에 저장 자동 개행
    CSV.open('opgg.csv','a+') do |c|
      c << [@userName, @win, @losem, @rank]
      erb :opggresult
    end
    
        
    


end


