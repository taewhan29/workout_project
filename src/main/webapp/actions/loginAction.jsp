<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="common.DBConnection" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("user_id");
    String userPassword = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT password FROM Users WHERE user_id = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        
        rs = pstmt.executeQuery();

        if (rs.next()) {
            if (rs.getString("password").equals(userPassword)) {
                session.setAttribute("userId", userId);
                out.println("<script>");
                out.println("alert('로그인에 성공했습니다.');");
                // ★ 핵심 수정: 상위 폴더의 main.jsp로 이동하도록 ../ 추가
                out.println("location.href = '../main.jsp';"); 
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('비밀번호가 일치하지 않습니다.');");
                out.println("history.back();");
                out.println("</script>");
            }
        } else {
            out.println("<script>");
            out.println("alert('존재하지 않는 아이디입니다.');");
            out.println("history.back();");
            out.println("</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>