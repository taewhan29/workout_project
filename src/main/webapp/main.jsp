<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, common.DBConnection"%>
<%
String userId = (String) session.getAttribute("userId");
if (userId == null) {
	out.println("<script>alert('로그인이 필요합니다.'); location.href='user/login.jsp';</script>");
	return;
}

String userName = "";
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
	conn = DBConnection.getConnection();
	String sql = "SELECT name FROM Users WHERE user_id = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, userId);
	rs = pstmt.executeQuery();
	if (rs.next()) {
		userName = rs.getString("name");
	}
} catch (Exception e) {
	e.printStackTrace();
} finally {
	if (rs != null) try { rs.close(); } catch (Exception e) { }
	if (pstmt != null) try { pstmt.close(); } catch (Exception e) { }
	if (conn != null) try { conn.close(); } catch (Exception e) { }
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Workout Tracker</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
	background-color: #f8f9fa;
	font-family: 'Pretendard', sans-serif;
}

.navbar-custom {
	background-color: #8bb8e8;
}

.navbar-custom .navbar-brand, .navbar-custom .nav-link {
	color: white;
	font-weight: bold;
}

.btn-custom {
	background-color: #8bb8e8;
	color: white;
	font-weight: bold;
	border: none;
	transition: 0.3s;
}

.btn-custom:hover {
	background-color: #75a2d1;
	color: white;
	transform: translateY(-2px);
}

.card {
	border-radius: 15px;
	transition: 0.3s;
}

.card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
}

.icon-img {
	width: 80px;
	height: 80px;
	margin-bottom: 20px;
}
</style>
</head>
<body>

	<nav class="navbar navbar-expand-lg navbar-custom shadow-sm">
		<div class="container">
			<a class="navbar-brand" href="main.jsp">WORKOUT TRACKER</a>
			<div class="collapse navbar-collapse">
				<ul class="navbar-nav me-auto">
					<li class="nav-item"><a class="nav-link" href="workoutLog.jsp">운동 일지</a></li>
					<li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/supplements">보충제 관리</a></li>
					 	<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/physicalInfo">신체 변화</a></li>
					<li class="nav-item"><a class="nav-link" href="myPage.jsp">마이페이지</a></li>
				</ul>
				<div class="d-flex align-items-center">
					<span class="text-white me-3 fw-bold"><%=userName%> 님</span> 
                    <a href="actions/logoutAction.jsp" class="btn btn-sm btn-light text-secondary fw-bold">로그아웃</a>
				</div>
			</div>
		</div>
	</nav>

	<div class="container mt-5">
		<h4 class="mb-4 fw-bold text-secondary">대시보드</h4>
		
        <div class="row">
            <div class="col-md-4 mb-4">
				<div class="card shadow-sm border-0 h-100">
					<div class="card-body text-center py-5">
						<img src="https://img.icons8.com/?size=100&id=aXNEW2aAGnsY&format=png&color=000000" class="icon-img" alt="운동 기록">
						<h5 class="card-title fw-bold">오늘의 운동</h5>
						<p class="card-text text-muted small">루틴을 기록하고<br>세트 데이터를 관리하세요.</p>
						<button type="button" class="btn btn-custom px-4 mt-2" data-bs-toggle="modal" data-bs-target="#workoutModal">기록하기</button>
					</div>
				</div>
			</div>

            <div class="col-md-4 mb-4">
				<div class="card shadow-sm border-0 h-100">
					<div class="card-body text-center py-5">
						<img src="https://img.icons8.com/?size=100&id=MeZiNPN5N5O1&format=png&color=000000" class="icon-img" alt="보충제 현황">
						<h5 class="card-title fw-bold">보충제 현황</h5>
						<p class="card-text text-muted small">남은 재고를 확인하고<br>섭취량을 체크하세요.</p>
						<a href="<%= request.getContextPath() %>/supplements" class="btn btn-custom px-4 mt-2">관리하기</a>
					</div>
				</div>
			</div>

            <div class="col-md-4 mb-4">
				<div class="card shadow-sm border-0 h-100">
					<div class="card-body text-center py-5">
						<img src="https://img.icons8.com/?size=100&id=103987&format=png&color=000000" class="icon-img" alt="내 정보">
						<h5 class="card-title fw-bold">신체 변화</h5>
						<p class="card-text text-muted small">그래프로 시각화된<br>성장 지표를 확인하세요.</p>
						<a href="physicalHistory.jsp" class="btn btn-custom px-4 mt-2">확인하기</a>
					</div>
				</div>
			</div>
		</div> 
	</div>

    <jsp:include page="includes/workoutModal.jsp" />

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>