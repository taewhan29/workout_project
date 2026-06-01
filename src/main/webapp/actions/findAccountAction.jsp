<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="common.DBConnection" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계정 확인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card-header-custom { background-color: #8bb8e8; color: white; font-weight: bold; }
        .btn-custom { background-color: #8bb8e8; color: white; font-weight: bold; border: none; }
        .btn-custom:hover { background-color: #75a2d1; color: white; }
        .form-control:focus { border-color: #8bb8e8; box-shadow: 0 0 0 0.25rem rgba(139, 184, 232, 0.25); }
    </style>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT user_id FROM Users WHERE name = ? AND email = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String userId = rs.getString("user_id");
            session.setAttribute("resetUserId", userId);
%>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header-custom text-center py-3 rounded-top">
                        <h5 class="mb-0">계정 확인 및 비밀번호 재설정</h5>
                    </div>
                    <div class="card-body p-4 text-center">
                        <p class="mb-4">확인된 아이디는 <strong class="text-primary"><%= userId %></strong> 입니다.</p>
                        <hr>
                        <p class="text-muted small mb-4">보안을 위해 새로운 비밀번호를 설정해주세요.</p>
                        
                        <form action="../actions/resetPwAction.jsp" method="post">
                            <div class="mb-3 text-start">
                                <label for="new_password" class="form-label fw-bold">새 비밀번호</label>
                                <input type="password" class="form-control" id="new_password" name="new_password" required placeholder="새 비밀번호 입력">
                            </div>
                            <div class="mb-4 text-start">
                                <label for="confirm_password" class="form-label fw-bold">비밀번호 확인</label>
                                <input type="password" class="form-control" id="confirm_password" name="confirm_password" required placeholder="비밀번호 다시 입력">
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-custom btn-lg">비밀번호 변경하기</button>
                                <button type="button" class="btn btn-outline-secondary" onclick="location.href='../user/login.jsp'">로그인 페이지로</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%
        } else {
            out.println("<script>alert('일치하는 정보가 없습니다.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
</body>
</html>