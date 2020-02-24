<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅</title>
<style>
	#chatArea{
		width:200px;
		height:100px;
		overflow-y:auto;
		border:1px solid black;	
	}
</style>
</head>
<body>
	<a href="./">메인화면으로 이동</a><br/>
	이름<input type="text" id="nickname"/>
	<input type="button" id="enterbtn" value="입장"/>
	<input type="button" id="exitbtn" value="나가기"/>
	
	<h1>채팅방</h1>
	<div id="chatArea">
		<div id="chatmessagearea"></div>
	</div>
	<br />
	
	<input type="text" id="message"/>
	<input type="button" id="sendbtn" value="전송"/>
	
	<script>
		//웹 소켓 변수
		var wsocket
		
		//변수에 이름을 기재하고 함수를 대입하면
		//이 함수를 만들고 난 후 뒤에서 사용가능해집니다.
		//function 이름(매개변수){} 로 만들면 순서에 상관없이 아무곳에서나 호출 가능
		
		//문자열을 출력하는 함수
		var appendMessage = function(msg){
			document.getElementById("chatmessagearea").innerHTML =
				msg + "<br/>" +
				document.getElementById("chatmessagearea").innerHTML
		}
		
		
		//이벤트 처리 함수
		var onOpen = function(){
			appendMessage("연결 되었습니다.")
		}
		var onClose = function(){
			appendMessage("연결 해제되었습니다.")
		}
		var onMessage = function(evt){
			var data = evt.data;
			appendMessage(data);
		}
		var send = function(){
			var nickname = document.getElementById("nickname").value;
			var msg = document.getElementById("message").value;
			wsocket.send(nickname + ":" + msg)
			document.getElementById("message").value = '';
		}
		
		
		
		//웹 소켓 연결 함수
		var connect = function(){
			wsocket = new WebSocket("ws://localhost:9000/db/chat-ws")
			//이벤트 핸들러 연결
			wsocket.addEventListener("open", onOpen);
			wsocket.addEventListener("message", onMessage);
		};
		
		
		//message 입력란에서 키보드 이벤트가 발생하면
		document.getElementById("message").addEventListener("keypress", function(e){
			event = e || window.event;
			var keycode = (event.keyCode?event.keyCode:event.which);
			if(keycode == 13){
				send()
			}
			event.stopPropagation();
		})
		
		//버튼들의 이벤트 처리
		document.getElementById('sendbtn').addEventListener("click", function(){
			send();
		})
		document.getElementById('enterbtn').addEventListener("click", function(){
			connect();
		})
		document.getElementById('exitbtn').addEventListener("click", function(){
			onClose();
		})

	
	
	</script>
	
</body>
</html>