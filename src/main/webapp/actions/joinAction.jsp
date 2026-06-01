<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="common.DBConnection" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("user_id");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String gender = request.getParameter("gender");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "INSERT INTO Users (user_id, password, email, name, gender, join_date) VALUES (?, ?, ?, ?, ?, CURDATE())";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, password);
        pstmt.setString(3, email);
        pstmt.setString(4, name);
        pstmt.setString(5, gender);

        int result = pstmt.executeUpdate();

        if (result == 1) {
            out.println("<script>");
            out.println("alert('회원가입이 완료되었습니다. 로그인 해주세요.');");
            out.println("location.href = '../user/login.jsp';");
            out.println("</script>");
        }
    } catch (Exception e) {
        out.println("<script>");
        out.println("alert('회원가입에 실패했습니다. 아이디가 중복되었거나 입력값이 잘못되었습니다.');");
        out.println("history.back();");
        out.println("</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>