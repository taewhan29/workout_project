<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, common.DBConnection" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='" + request.getContextPath() + "/user/login.jsp';</script>");
        return;
    }

    String logIdParam = request.getParameter("log_id");
    if (logIdParam == null || logIdParam.trim().isEmpty()) {
        out.println("<script>alert('유효하지 않은 접근입니다.'); location.href='" + request.getContextPath() + "/workoutLog.jsp';</script>");
        return;
    }

    int logId = Integer.parseInt(logIdParam);
    Connection conn = null;
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        String deleteSetsSql = "DELETE FROM Set_Records WHERE log_id = ?";
        pstmt1 = conn.prepareStatement(deleteSetsSql);
        pstmt1.setInt(1, logId);
        pstmt1.executeUpdate();

        String deleteLogSql = "DELETE FROM Workout_Logs WHERE log_id = ? AND user_id = ?";
        pstmt2 = conn.prepareStatement(deleteLogSql);
        pstmt2.setInt(1, logId);
        pstmt2.setString(2, userId);
        
        int rowCount = pstmt2.executeUpdate();

        if (rowCount > 0) {
            conn.commit();
%>
            <script>
                alert('운동 기록이 성공적으로 삭제되었습니다.');
                location.href = '<%= request.getContextPath() %>/workoutLog.jsp';
            </script>
<%
        } else {
            conn.rollback();
%>
            <script>
                alert('삭제 권한이 없거나 존재하지 않는 기록입니다.');
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
            alert('데이터베이스 처리 중 오류가 발생했습니다.');
            history.back();
        </script>
<%
    } finally {
        if (pstmt1 != null) try { pstmt1.close(); } catch (Exception e) {}
        if (pstmt2 != null) try { pstmt2.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>