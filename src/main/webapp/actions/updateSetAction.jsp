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
    String workoutDate = request.getParameter("workout_date");
    String bodyWeightStr = request.getParameter("body_weight");
    String conditionNote = request.getParameter("condition_note");

    String[] setOrders = request.getParameterValues("set_order[]");
    String[] workoutIds = request.getParameterValues("workout_id[]");
    String[] weights = request.getParameterValues("weight[]");
    String[] reps = request.getParameterValues("reps[]");

    if (logIdParam == null || workoutDate == null) {
        out.println("<script>alert('필수 파라미터가 유실되었습니다.'); history.back();</script>");
        return;
    }

    int logId = Integer.parseInt(logIdParam);
    double bodyWeight = 0;
    if (bodyWeightStr != null && !bodyWeightStr.trim().isEmpty()) {
        bodyWeight = Double.parseDouble(bodyWeightStr);
    }

    Connection conn = null;
    PreparedStatement pstmtCheck = null;
    PreparedStatement pstmtMaster = null;
    PreparedStatement pstmtDelete = null;
    PreparedStatement pstmtInsert = null;
    ResultSet rsCheck = null;

    try {
        conn = DBConnection.getConnection();
        
        String checkSql = "SELECT user_id FROM Workout_Logs WHERE log_id = ?";
        pstmtCheck = conn.prepareStatement(checkSql);
        pstmtCheck.setInt(1, logId);
        rsCheck = pstmtCheck.executeQuery();
        
        if (rsCheck.next()) {
            if (!rsCheck.getString("user_id").equals(userId)) {
                out.println("<script>alert('수정 권한이 없습니다.'); history.back();</script>");
                return;
            }
        } else {
            out.println("<script>alert('존재하지 않는 일지입니다.'); history.back();</script>");
            return;
        }

        conn.setAutoCommit(false);

        String masterSql = "UPDATE Workout_Logs SET workout_date = ?, body_weight = ?, condition_note = ? WHERE log_id = ?";
        pstmtMaster = conn.prepareStatement(masterSql);
        pstmtMaster.setString(1, workoutDate);
        pstmtMaster.setDouble(2, bodyWeight);
        pstmtMaster.setString(3, conditionNote);
        pstmtMaster.setInt(4, logId);
        pstmtMaster.executeUpdate();

        String deleteSql = "DELETE FROM Set_Records WHERE log_id = ?";
        pstmtDelete = conn.prepareStatement(deleteSql);
        pstmtDelete.setInt(1, logId);
        pstmtDelete.executeUpdate();

        if (weights != null) {
            String insertSql = "INSERT INTO Set_Records (log_id, workout_id, set_order, weight, reps, rest_time) VALUES (?, ?, ?, ?, ?, ?)";
            pstmtInsert = conn.prepareStatement(insertSql);
            
            for (int i = 0; i < weights.length; i++) {
                if (weights[i].isEmpty() || reps[i].isEmpty()) continue;
                
                pstmtInsert.setInt(1, logId);
                pstmtInsert.setInt(2, Integer.parseInt(workoutIds[i]));
                pstmtInsert.setInt(3, Integer.parseInt(setOrders[i]));
                pstmtInsert.setDouble(4, Double.parseDouble(weights[i]));
                pstmtInsert.setInt(5, Integer.parseInt(reps[i]));
                pstmtInsert.setInt(6, 60);
                pstmtInsert.addBatch();
            }
            pstmtInsert.executeBatch();
        }

        conn.commit();
        out.println("<script>alert('일지 및 하위 세트 정보가 통합 수정되었습니다.'); location.href='../workoutLog.jsp';</script>");

    } catch (Exception e) {
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException ex) {}
        }
        e.printStackTrace();
        out.println("<script>alert('처리 도중 데이터베이스 에러가 발생하여 롤백되었습니다.'); history.back();</script>");
    } finally {
        if (rsCheck != null) try { rsCheck.close(); } catch (Exception e) {}
        if (pstmtCheck != null) try { pstmtCheck.close(); } catch (Exception e) {}
        if (pstmtMaster != null) try { pstmtMaster.close(); } catch (Exception e) {}
        if (pstmtDelete != null) try { pstmtDelete.close(); } catch (Exception e) {}
        if (pstmtInsert != null) try { pstmtInsert.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>