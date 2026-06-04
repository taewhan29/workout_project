<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, common.DBConnection" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='" + request.getContextPath() + "/user/login.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt3 = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        String deleteSetsSql = "DELETE FROM Set_Records WHERE log_id IN (SELECT log_id FROM Workout_Logs WHERE user_id = ?)";
        pstmt1 = conn.prepareStatement(deleteSetsSql);
        pstmt1.setString(1, userId);
        pstmt1.executeUpdate();

        String deleteLogsSql = "DELETE FROM Workout_Logs WHERE user_id = ?";
        pstmt2 = conn.prepareStatement(deleteLogsSql);
        pstmt2.setString(1, userId);
        pstmt2.executeUpdate();

        String deleteUserSql = "DELETE FROM Users WHERE user_id = ?";
        pstmt3 = conn.prepareStatement(deleteUserSql);
        pstmt3.setString(1, userId);
        int result = pstmt3.executeUpdate();

        if (result > 0) {
            conn.commit();
            session.invalidate();
%>
            <script>
                alert('회원 탈퇴가 완료되었습니다. 그동안 이용해 주셔서 감사합니다.');
                location.href = '<%= request.getContextPath() %>/main.jsp';
            </script>
<%
        } else {
            conn.rollback();
%>
            <script>
                alert('탈퇴 처리 중 문제가 발생했습니다.');
                history.back();
            </script>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
        }
%>
        <script>
            alert('데이터베이스 오류로 탈퇴 처리에 실패했습니다.');
            history.back();
        </script>
<%
    } finally {
        if (pstmt1 != null) try { pstmt1.close(); } catch (Exception e) {}
        if (pstmt2 != null) try { pstmt2.close(); } catch (Exception e) {}
        if (pstmt3 != null) try { pstmt3.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>