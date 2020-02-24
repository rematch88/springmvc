<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>데이터 삽입</title>
</head>
<body>
	<div align='center'>
		<h3>데이터 삽입</h3>
		<form method="post" enctype="multipart/form-data"
		id="myform">
			<table border="1">
				<tr>
					<td rowspan="5" align="center">
						<p></p>
						<img id="img" width="100" height="100"
							border="1"/>
						<br/>
						<input type="file" id="pictureurl"
						name="pictureurl"
						accept=".jpg,.jpeg,.gif,.png" />
						<br />
					</td>
				</tr>
				
				<tr>
					<td align="right">코드</td>
					<td><input type="text" name="itemid"
					id="itemid" required="required" />
					<div id="iddiv"></div>
					</td>
				</tr>
				<tr>
					<td align="right">이름</td>
					<td><input type="text" name="itemname"
					id="itemname" required="required" />
					</td>
				</tr>
				<tr>
					<td align="right">가격</td>
					<td><input type="text" name="price"
					id="price" required="required" />
					</td>
				</tr>
				<tr>
					<td align="right">효과</td>
					<td><input type="text" name="description"
					id="description" required="required" />
					</td>
				</tr>
				<tr>
					<td colspan="3" align="center">
						<input type="submit" value="전송" />
						<input type="button" value="메인" 
						id="mainbtn"/>
					</td>
				</tr>		
						
			</table>
		</form>
	</div>
	
	
	<script>
		//이미지 미리보기
		var pictureurl = document.getElementById("pictureurl")
		var img = document.getElementById("img");
		
		//이미지 선택이 변경되면
		pictureurl.addEventListener("change", function(){
			//업로드한 이미지 파일의 내용을 img에 출력
			
			//파일 객체 생성
			var reader = new FileReader();
			//선택한 파일이 있다면
			if(pictureurl.files && pictureurl.files[0]){
				//파일 읽기
				reader.readAsDataURL(pictureurl.files[0]);
				//파일의 내용을 전부 읽으면 출력
				reader.addEventListener("load", function(e){
					img.src = e.target.result;
				})
			}
		});
		
		//itemid 중복 체크를 위한 변수
		var itemid = document.getElementById("itemid");
		var iddiv = document.getElementById("iddiv");
		
		//중복체크를 통과했는지 여부를 저장할 변수
		var idcheck = false;
		
		//itemid 란에서 포커스가 떠나면 중복 체크
		itemid.addEventListener("focusout", function(e){
			//ajax 객체 만들기
			request = new XMLHttpRequest();
			//요청 생성
			request.open('GET', 'itemidcheck?itemid=' + itemid.value);
			//요청 전송
			request.send('');
			//요청에 대한 처리를 위한 콜백 메소드 등록
			request.onreadystatechange = function(){
				//정상 응답이 오면
				if(request.readyState == 4 && 
					request.status >= 200 && request.status < 300){
					//넘어온 데이터 파싱
					var data = JSON.parse(request.responseText);
					if(data.result == 'true'){
						iddiv.innerHTML = '멋진 코드네요';
						iddiv.style.color = 'green';
						idcheck.value = true;
					}else{
						iddiv.innerHTML = '이미 사용 중인 코드입니다.';
						iddiv.style.color = 'red';
						idcheck.value = false;
					}
					
				}
			}
		});
		
		//폼의 데이터를 전송할 때 발생하는 이벤트 처리
		document.getElementById("myform").addEventListener("submit",function(e){
			//중복 체크 통과여부 확인
			if(idcheck.value == false){
				iddiv.innerHTML = '아이디 중복검사를 하세요';
				iddiv.style.color = 'red';
				itemid.focus();
				//폼의 데이터를 전송하지 않도록 하기
				e.preventDefault();
				return;
			}
			
			var price = document.getElementById("price");
			//price 입력 란의 숫자만 입력되었는지 체크
			//+ 나 - 기호를 앞에 붙일 수 있는지
			//,의 경우는 어떻게 할것인지
			for(var i=0; i<price.value.length; i=i+1){
				var ch = price.value.charAt(i);
				if(i == 0){
					if(!(ch == '+' || ch == '-' || (ch >= '0' && ch <= '9'))){
						price.focus();
						alert("가격의 첫번째 자리는 숫자나 +, - 기호여야 합니다.")
						//폼의 데이터를 전송하지 않도록 하기
						e.preventDefault();
						return;
					}
				}else{
					if(!(ch >= '0' && ch <= '9')){
						price.focus();
						alert("가격은 숫자로만 입력하세요!!!")
						//폼의 데이터를 전송하지 않도록 하기
						e.preventDefault();
						return;
					}
				}
			}
		});
	</script>


</body>
</html>







