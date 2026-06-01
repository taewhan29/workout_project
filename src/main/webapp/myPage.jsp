<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.* , common.DBConnection, java.util.* "%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='user/login.jsp';</script>");
        return;
    }

    String userName = "";
    String userEmail = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT name, email FROM Users WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            userName = rs.getString("name");
            userEmail = rs.getString("email");
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
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .navbar-custom { background-color: #8bb8e8; }
        .navbar-custom .navbar-brand, .navbar-custom .nav-link { color: white; font-weight: bold; }
        .card-profile { border: none; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); background-color: white; padding: 30px; margin-top: 50px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom mb-4">
    <div class="container">
        <a class="navbar-brand" href="main.jsp">WORKOUT TRACKER</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-link" style="color: white; margin-right: 15px;"><%= userName %> 님</li>
                <li class="nav-item"><a class="nav-link" href="workoutLog.jsp">운동일지</a></li>
                <li class="nav-item"><a class="nav-link" href="logoutAction.jsp">로그아웃</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container" style="max-width: 600px;">
    <div class="card card-profile">
        <h4 class="mb-4 text-dark fw-bold border-bottom pb-2">내 정보</h4>
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label text-muted fw-semibold">아이디</label>
            <div class="col-sm-9">
                <input type="text" readonly class="form-control-plaintext fw-bold" value="<%= userId %>">
            </div>
        </div>
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label text-muted fw-semibold">이름</label>
            <div class="col-sm-9">
                <input type="text" readonly class="form-control-plaintext fw-bold" value="<%= userName %>">
            </div>
        </div>
        <div class="mb-4 row">
            <label class="col-sm-3 col-form-label text-muted fw-semibold">이메일</label>
            <div class="col-sm-9">
                <input type="text" readonly class="form-control-plaintext fw-bold" value="<%= userEmail %>">
            </div>
        </div>
        <div class="d-flex justify-content-between border-top pt-4">
            <a href="main.jsp" class="btn btn-secondary fw-bold">홈으로</a>
            <button type="button" class="btn btn-danger fw-bold" onclick="confirmWithdraw()">회원 탈퇴</button>
        </div>
    </div>
</div>

<script>
function confirmWithdraw() {
    if(confirm("회원 탈퇴 시 그동안 기록된 모든 운동 일지와 세트 기록이 영구히 삭제되며 복구할 수 없습니다.\n정말 탈퇴하시겠습니까?")) {
        location.href = "actions/withdrawAction.jsp";
    }
}
</script>

</body>
</html>