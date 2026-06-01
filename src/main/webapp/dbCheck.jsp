<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="common.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB 연결 테스트</title>
</head>
<body>
    <h2>운동 프로젝트 DB 연결 테스트</h2>
    <%
        Connection conn = DBConnection.getConnection();
        if(conn != null) {
            out.println("<h3 style='color:blue;'>MySQL 연결 성공</h3>");
            conn.close(); // 확인 후 닫기
        } else {
            out.println("<h3 style='color:red;'>연결 실패 에러 메시지를 확인</h3>");
        }
    %>
</body>
</html>