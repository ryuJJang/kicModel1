<%@page import="model.Board"%>
<%@page import="java.util.List"%>
<%@page import="service.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
* {
	margin: 0;
	padding: 0;
}

body {
	font-family: "Times New Roman", Georgia, Serif;
}

h1, h2, h3, h4, h5, h6 {
	font-family: "Playfair Display";
	letter-spacing: 5px;
}

table {
	border-collapse: collapse;
}

caption {
	padding: 25px;
	font-size: 30px;
}

a {
	color: black;
}

.tbl_wrap {
	padding: 200px;
}

.tbl {
	width: 100%;
}

.tbl th, .tbl td {
	padding: 10px;
	border: 1px solid #999;
}

.tbl th {
	background: gray;
	color: white;
	font-size: 18px;
}

.tbl th.count {
	background: white;
	color: black;
	font-size: 13px;
	text-align: right;
}

.tbl td {
	text-align: center;
	font-size: 15px;
}

.tbl tbody tr td:nth-child(2) {
	width: 50%;
	text-align: left;
}

.login_wrap {
	padding: 100px;
}

.login caption {
	text-align: center;
	font-size: 23px;
}

.login {
	width: 1500;
	border-collapse: collapse;
}

.login td {
	border: 1px solid #999;
	text-align: center;
	padding: 10px 0;
	width: 10%;
}

.login tbody td:first-child {
	background: gray;
}

.image {
	font-size: 13px;
}

a {
	color: black;
}

.wrap {
	padding: 100px;
}

.tbll caption {
	text-align: center;
	font-size: 23px;
}

.tbll {
	width: 100%;
	border-collapse: collapse;
}

.tbll td {
	border: 1px solid #999;
	text-align: center;
	padding: 10px 0;
	width: 10%;
}
</style>
<body>
	<%
		String boardid = "1";
		int pageInt = 2;
		int limit = 3;
		
		try{
		pageInt = Integer.parseInt(request.getParameter("pageNum"));
		}catch(Exception e){
			pageInt = 1;
		}
	BoardDao bd = new BoardDao();
	int boardcount = bd.boardCount(boardid);

	
	/*
	-- 1,4, 7, 10
	-- start: (pageInt-1)*limit +1;
	-- end : start + limit -1;
	-- 1p --> count
	-- 2p --> count - 1 * limit~
	-- 3p --> count - 2 * limit
	*/
	
	List<Board> list = bd.boardList(pageInt, limit, boardcount, boardid);
	
	int boardnum = boardcount - (pageInt -1) * limit;
	
	/*
	-- 1p --> boardcount
	-- 2p --> boardcount - 1 * limit~
	-- 3p --> boardcount - 2 * limit
	*/
	
	int bottomLine = 3;
	int startPage = (pageInt -1)/ bottomLine * bottomLine +1;
	int endPage = startPage + bottomLine -1;
	int maxPage = (boardcount  / limit) + (boardcount % limit == 0 ? 0 : 1);
	if (endPage > maxPage) endPage = maxPage;
	
	
	/*
	-- 1p --> startpage = 1 (p-1)/3*3+1
	-- 2p --> startpage = 1
	-- 3p --> startpage = 1
	-- 4p --> startpage = 4
	-- 5p --> startpage = 4
	-- 6p --> startpage = 4
	*/
	
	%>
	<hr>
	<!-- table list start -->
	
	<div class="w3-bar w3-white w3-padding w3-card" style="letter-spacing: 4px;">
			<a href="#home" class="w3-bar-item w3-button">KIC Campus</a>
			<div class="w3-right w3-hide-small">
			<a href="#about" class="w3-bar-item w3-button">회원가입</a>
			<a href="#menu" class="w3-bar-item w3-button">공지사항</a>
			<a href="#contact" class="w3-bar-item w3-button">로그인</a>
			</div>
		
		<div class = "tbl_wrap">
		<table class="tbl">
		<caption>공지사항</caption>
			<thead>
				<tr>
				<th colspan="6" class="count">
				<p align = "right">
		<% if (boardcount > 0) {%>글 개수 <%=boardcount %><%} else { %>
		등록된 게시물이 없습니다
		<%} %></p></th>
				</tr>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>등록일</th>
					<th>파일</th>
					<th>조회수</th>

				</tr>
			</thead>
			<tbody>
			<%
			for(Board b : list){
				%>	
			
				<tr>
					<td><%=(boardnum--) %></td>
					<td><a href="boardInfo.jsp?num=<%=b.getNum()%>"><%=b.getSubject() %></a></td>
					<td><%=b.getWriter() %></td>
					<td><%=b.getRegdate() %></td>
					<td><%=b.getFile1() %></td>
					<td><%=b.getReadcnt() %></td>
				</tr>
				<%}
			%>
			</tbody>
		</table>
		
		<p align="right">
			<a href="<%=request.getContextPath() %>/view/board/wirteForm.jsp">게시판입력</a></p>
		<div class="container">
			<ul class="pagination justify-content-center">
				<li class="page-item <% if (startPage <= bottomLine){ %> disabled <% } %> ">
				<a class="page-link" href="list.jsp?pageNum=<%=startPage-bottomLine%>">Previous</a></li>

				<% for (int i = startPage; i <=endPage; i++) { %>
				<li class="page-item <% if (i==pageInt){ %> active <% } %>">
				<a class="page-link" href="list.jsp?pageNum=<%=i %>"><%=i %></a></li>
				<%} %>
				
				<li class="page-item <% if (endPage >= maxPage){ %> disabled <% } %> ">
				<a class="page-link" href="list.jsp?pageNum=<%=startPage+bottomLine%>">Next</a></li>

			</ul>
			</div>
		</div>
	</div>
	<div class="wrap">
		<table class="tbll">
			<caption>회원가입</caption>
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
			</colgroup>
			<tbody>
				<tr>
					<td rowspan="4" class="image"><img src="img.jpg"> <br>
						<input type='file'> <br> <a href="#">사진등록</a></td>
					<td>아이디</td>
					<td><input type="text"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password"></td>
				</tr>
				<tr>

					<td>이름</td>
					<td><input type="text"></td>
				</tr>
				<tr>

					<td>성별</td>
					<td><input type='radio' checked name="gender">남 <input
						type='radio' checked name="gender">여</td>

				</tr>
				<tr>
					<td>전화번호</td>
					<td colspan="2"><input type="text"></td>

				</tr>
				<tr>
					<td>이메일</td>
					<td colspan="2"><input type="text"></td>

				</tr>
				<tr>
					<td colspan="3"><button>회원가입</button></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="login_wrap">
		<table class="login">
			<caption>로그인</caption>
			<tbody>
				<tr>
					<td>아이디</td>
					<td><input type="text"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password"></td>
				</tr>
				<tr>
					<td colspan="2"><button>로그인</button>
						<button>회원가입</button></td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>