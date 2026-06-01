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
    String setOrderParam = request.getParameter("set_order");
    String weightParam = request.getParameter("weight");
    String repsParam = request.getParameter("reps");

    if (logIdParam == null || setOrderParam == null || weightParam == null || repsParam == null) {
        out.println("<script>alert('필수 데이터가 누락되었습니다.'); history.back();</script>");
        return;
    }

    int logId = Integer.parseInt(logIdParam);
    int setOrder = Integer.parseInt(setOrderParam);
    double weight = Double.parseDouble(weightParam);
    int reps = Integer.parseInt(repsParam);

    Connection conn = null;
    PreparedStatement pstmtCheck = null;
    PreparedStatement pstmtUpdate = null;
    ResultSet rsCheck = null;

    try {
        conn = DBConnection.getConnection();
        
        String checkSql = "SELECT user_id FROM Workout_Logs WHERE log_id = ?";
        pstmtCheck = conn.prepareStatement(checkSql);
        pstmtCheck.setInt(1, logId);
        rsCheck = pstmtCheck.executeQuery();
        
        if (rsCheck.next()) {
            String ownerId = rsCheck.getString("user_id");
            if (!ownerId.equals(userId)) {
%>
                <script>
                    alert('수정 권한이 없습니다.');
                    history.back();
                </script>
<%
                return;
            }
        } else {
%>
            <script>
                alert('존재하지 않는 운동 일지입니다.');
                history.back();
            </script>
<%
            return;
        }

        String updateSql = "UPDATE Set_Records SET weight = ?, reps = ? WHERE log_id = ? AND set_order = ?";
        pstmtUpdate = conn.prepareStatement(updateSql);
        pstmtUpdate.setDouble(1, weight);
        pstmtUpdate.setInt(2, reps);
        pstmtUpdate.setInt(3, logId);
        pstmtUpdate.setInt(4, setOrder);
        
        int result = pstmtUpdate.executeUpdate();

        if (result > 0) {
%>
            <script>
                alert('세트 정보가 수정되었습니다.');
                location.href = '<%= request.getContextPath() %>/workoutLog.jsp';
            </script>
<%
        } else {
%>
            <script>
                alert('수정 처리에 실패했습니다.');
                history.back();
            </script>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert('데이터베이스 처리 중 오류가 발생했습니다.');
            history.back();
        </script>
<%
    } finally {
        if (rsCheck != null) try { rsCheck.close(); } catch (Exception e) {}
        if (pstmtCheck != null) try { pstmtCheck.close(); } catch (Exception e) {}
        if (pstmtUpdate != null) try { pstmtUpdate.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>