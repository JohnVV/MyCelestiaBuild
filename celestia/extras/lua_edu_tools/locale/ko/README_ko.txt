********************************************************
*	LUA EDU 1.2 TOOLS FOR CELESTIA 1.6
*	(c) 2008
*	Vincent Giangiulio <vince.gian@free.fr>
*	Hank Ramsey
********************************************************

--------------------------------------------------------
LUA EDU TOOLS이란?
--------------------------------------------------------
'Lua Edu Tools'는 Celestia 1.6를 위해 다음 기능을 제공하는 애드온이다. :
- Celestia를 실행할 수 있게 해주기 위한 주 명령어들을 학생이나 초보 사용자들이 완전히 독립적으로 
쉽게 접근하게 해주는 그래픽 인터페이스
- Celestia 1.6에 가능하지 않는 새로운 기능들: 나침반, 상세 정보/그림, 거리 표시기, 기타 등등...

그래픽 인터페이스는 다음 요소들을 포함한다:
  > 시스템의 지역식별자 포멧에 맞는 시뮬레이션 날짜와 시간, 시간 흐름 조정 슬라이더, 시간/날짜 설정 옵션
  > 주변 빛 세기 슬라이더
  > 밝기 조정 (AutoMag) 슬라이더
  > 은하계 광도 이익 슬라이더
  > 표시 옵션 설정
  > 네비게이션 버튼: 태양으로 이동, 선택 천체로 이동, 선택 천체와 동기, 자전 동기, 선택 천체를 중앙
  > 천체의 종류(행성, 달, 소행성, ...)에 따라 분류하여 보여 주는 태양계 브라우저
  > 시야(FOV) 슬라이더
  > 애드온 적용 설정 옵션
  > 상세 정보 표시 (infoText 파일)과 슬라이드쇼 형태로 출력되는 이미지 (infoImage)
  > 거리 표시기
     - 화면 가운데에 위치한 관찰자 기준 평면에서의 사각형 거리 표시기
     - 선택한 천체를 중심으로 적도면에서의 원형 거리 표시기
  > 태양계의 교육적 표시를 위한 확대 옵션 (천체들이 확대되어 표시됨)
  > 좌/우 이동(yaw)와 상/하 이동 (pitch)의 조정을 쉽게 하기 위한 버추얼 패드
  > 나침반: (나침반을 클릭하면 화면상의 위치를 변경할 수 있다.)
     - 플라네터륨/네비게이션 모드 버튼
     - 경도/위도 혹은 방위/고드 (클릭시 변경)

[Shift]+[G]를 통해 이용 가능한 '커스텀 이동' 명령은 현재 선택으로 이동하고 화면에 맞게 만든다. 
'커스텀 이동' 명령의 여행 시간은 설정 파일 에서 설정 가능하다. ('LUA EDU TOOLS 커스터마이즈 
하기' 섹션 참조) 

--------------------------------------------------------
LUA EDU TOOLS 설치
--------------------------------------------------------
1- 압축을 풀고, 'lua_edu_tools' 폴더를 'extras' 폴더로 복사하기
2- 'luahookinit.lua' 파일을 Celestia의 루트 폴더로 옮기기
3- celestia.cfg 파일에 다음 라인 추가하기
	Configuration
	{
	LuaHook "luahookinit.lua" # <-- Line to add
	...

Lua Edu Tools 1.2는 Celestia 1.6과 동작함:
http://www.shatters.net/celestia/download.html

--------------------------------------------------------
LUA EDU TOOLS 사용 방법
--------------------------------------------------------
- Lua Edu Tools이 설치 되면, Celstia가 실행될 때 마다 자동적으로 그래픽 인터페이스가
  출력된다.
- 툴박스의 오른쪽을 클릭하거나 [Shift]+[i]를 클릭해서 Lua Edua Tools를 활성화/비활성화
  할 수 있다.
- 그래픽 인터페이스가 활성화 되어 있어도 키보드 콘트롤과 같은 Celestia의 모든 표준
  기능은 모든 활성화 되어 있다.

--------------------------------------------------------
LUA EDU TOOLS 커스터마이즈 하기
--------------------------------------------------------
- Lua Edu Tools은 'config.lua' 파일을 통해서 쉽게 커스터마이즈 가능하다. 툴 박스에 포함하고자 
  하는 엘리먼트를 사용자가 설정 가능하고 Celestia가 시작할 때 Lua Edu Tools이 출력될지 않을지
  선택 가능하다. 사용자는 언어, 타임 존, 그래픽 인터페이스의 색상, 나침반의 기본 위치와 같은
  파라미터를 자신이 원하는데로 설정할 수 있다.
  'config.lua' 파일은 간단한 텍스트 에디터 (Notepad, ...)로 편집 가능하다.

- Lua Edu Tools는 이미 몇가지 언어를 지원한다. "en" (영어), "fr" (프랑스어), "ru" (러시아어),
  "sv" (스웨덴어), "de" (독일어) 그리고 "ko" (한국어)가 그것이다.
  Windows와 리눅스에서는, 시스템 지역식별자 언어 ('lang')이 자동적으로 인식된다.
  맥 상에서는, 사용자가 'config.lua' 파일의 'language' 항목을 원하는 언어로 설정할 수 있다.
  번역된 버전의 이 readme.txt 파일은 locale 폴더에 존재하는 각각 'lang' 폴더에서 찾을 수 있다.

- 추가적으로 상세 정보를 추가하려면, 'infos/infoText.lua' 파일 혹은 해당하는 언어의 
  'locale/lang/infoText_lang.lua' 파일을 편집한다.
  > 각 천체에 대해서 단순히 다음 라인을 추가한다.
     Name_of_object = [[ infoText ]];
  참조: 이름에 스페이스가 포함되어 있으면 ["Name of object"]을 사용한다.

- 상세 정보 이미지를 추가할 경우, 'infos/infoImage.lua' 파일을 수정한다.
  여러개의 이미지가 (슬라이드 쇼 처럼) 동일한 천체를 위해서 사용될 수 있다.
  > 각 천체에 대해서 단순히 다음 라인을 추가한다.
	   Name_of_object = { "image_filename_1"; "image_filename_2"; ... }
  참조: 이름에 스페이스가 포함되어 있으면 ["Name of object"]를 사용하고, 이미지 파일들을 'images'
  폴더에 넣는다.
- 사용자는 자신의 애드온을 '애드온 적용 설정' 옵션에 추가할 수 있다. 그렇게 하기 위해서, 사용자는 
  'adds/Political_Borders/Political_Borders.lua' 파일과 같이 모델과 같은 이름의 Lua 파일을
   만들어야 한다. 그런 후에, 'config.lua'의 'adds' 목록에 만든 Lua file의 이름을 추가하기만
   하면 된다. '애드온 적용' 창에 등록한 Lua 파일과 동일하게 출력된다. 단, 밑줄 '_'은 빈칸 (' ')으로
   치환된다.
   Lua 파일은 다음 값들을 포함하는 테이블을 가지고 있어야 한다.
    >  objects = { string:object1path, string:object2path, ... }
    활성/비활성으로 설정할 수 있는 천체들의 목록을 정의한다.
    >	labelcolor = {number:red, number:green, number:blue, number:alpha}
    애드온 이름의 색상을 설정한다. 설정이 된 경우, 애드온의 이름은 '애드온 적용' 창에 지정된 색상으로
    출력될 것이다.
    >	locationtype = string:location_type
    천체의 설정에 따라 함께 활성/비활성될 위치의 종류(location type)를 설정한다. 위치의 종류는 다음
    주소를 참조하도록 한다. http://en.wikibooks.org/wiki/Celestia/SSC_File#Type_.22string.22

--------------------------------------------------------
THE LUA EDU TOOLS의 INTERNATIONALIZATION에 기여하기:
--------------------------------------------------------
- 다음 파일들을 생성해서 Lua Edu Tools을 다른 언어로 번역하할 수 있다.
  > 'locale/lang/lang.lua'
  > 'locale/lang/infoText_lang.lua'
  > 'locale/lang/images/compass_lang.png'
  파일들의 예로서 'locale/fr/fr.lua', 'locale/fr/infoText_fr.lua', 그리고 
  'locale/fr/images/compass_fr.png'가 사용될 수 있다. 'image' 폴더에 제공되는 'compas.pds' 파일은 
  모든 레이어가 포함되어 있다. 이 'readme.txt' 파일 또한 번역되어야 한다.
  그런 후에는, 번역된 파일을 <vince.gian@free.fr>로 보내 주면, Lua Edu Tools의 정식 릴리즈시 
  포함될 것이다. 여러분의 기여에 감사를 표한다.

참조: .lua 파일은 원하는 텍스트 편집기 (Notepad, ...)로 편집 가능하다.
      Accentuated character 혹은 러시아, 그리스 문자, 키릴 문자 알파벳을 테스트에 추가할 필요가 있다면,
      Notepad2를 사용할 수도 있다.
          1- Notepad2를 다음 주소에서 다운로드 at: http://www.flos-freeware.ch/notepad2.html
          2- Notepad2에서 .lua 파일 열기: File > Open...
          3- UTF-8 encoding 선택: File > Encoding > UTF-8
          4- 원하는 텍스트를 추가하여 파일을 편집 후 저장: File > Save

--------------------------------------------------------
크레딧:
--------------------------------------------------------
- Lua Edu Tool은 비상업적 목적을 위해서는 자유롭게 사용/복사/변경/배포가 가능하다.
  이 'readme.txt' 파일은 'lua_edu_tool' 폴더에 원본을 보관하도록 요청한다.

- 상업적 목적을 위해서 Lua Edu Tool의 원본 혹은 변경된 버전을 사용하려고 할 경우, 
  원작자 <vince.gian@free.fr>의 허락을 받아야만 한다.

- compas.png와 compass_lang.png를 제외한 모든 이미지는 NASA [www.nasa.gov]의 협조를 받은 것이다.

- Lua Edu Tools의 Internationalization에 기여한 모든 번역자에게 감사를 전한다.
	DE: Ulrich Dickmann aka Adirondack <celestia-deutsch@gmx.net>
	RU: Sergey Leonov <leserg@ua.fm>
	SV: Anders Pamdal <anders@pamdal.se>

-	이 프로젝트에 대한 Christophe (ElChristou)의 소중한 도움과 기여에 대해 특별한 감사를 전한다.
  Martin (Chan),  Massimo (Fenerit)과 모든 테스터들에게 매우 큰도움이 되었던 리포트에 대한 감사를 전한다.
  Ken (Jedi)에게 원형 거리 표시기 구현에 대한 기여에 대해 큰 감사를 전한다.

@+
Vincent