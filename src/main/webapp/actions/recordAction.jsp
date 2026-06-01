<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, common.DBConnection, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    
    System.out.println("======= 저장 시작 =======");
    System.out.println("날짜: " + request.getParameter("workout_date"));

    String workoutDate = request.getParameter("workout_date");
    String bodyWeightStr = request.getParameter("body_weight");
    String conditionNote = request.getParameter("condition_note");

    double bodyWeight = 0;
    if (bodyWeightStr != null && !bodyWeightStr.trim().isEmpty()) {
        bodyWeight = Double.parseDouble(bodyWeightStr);
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); 

        String logSql = "INSERT INTO Workout_Logs (user_id, workout_date, body_weight, condition_note) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(logSql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, userId);
        pstmt.setString(2, workoutDate);
        pstmt.setDouble(3, bodyWeight);
        pstmt.setString(4, conditionNote);
        pstmt.executeUpdate();

        int generatedLogId = 0;
        rs = pstmt.getGeneratedKeys();
        if (rs.next()) {
            generatedLogId = rs.getInt(1);
            System.out.println("생성된 log_id: " + generatedLogId);
        }

        String[] blockIndices = request.getParameterValues("block_index");
        System.out.println("받은 블록 인덱스 배열: " + Arrays.toString(blockIndices));
        
        if (blockIndices != null) {
            String setSql = "INSERT INTO Set_Records (log_id, workout_id, set_order, weight, reps, rest_time) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement setPstmt = conn.prepareStatement(setSql);

            for (String bIdx : blockIndices) {
                String specificWorkoutId = request.getParameter("workout_id_" + bIdx);
                String[] weights = request.getParameterValues("weight_" + bIdx);
                String[] reps = request.getParameterValues("reps_" + bIdx);

                System.out.println("블록 " + bIdx + "의 운동ID: " + specificWorkoutId);

                if (weights != null && specificWorkoutId != null) {
                    for (int i = 0; i < weights.length; i++) {
                        if (weights[i].isEmpty() || reps[i].isEmpty()) continue;

                        setPstmt.setInt(1, generatedLogId);
                        setPstmt.setInt(2, Integer.parseInt(specificWorkoutId));
                        setPstmt.setInt(3, i + 1);
                        setPstmt.setDouble(4, Double.parseDouble(weights[i]));
                        setPstmt.setInt(5, Integer.parseInt(reps[i]));
                        setPstmt.setInt(6, 60);
                        setPstmt.addBatch();
                        System.out.println("   -> 세트 " + (i+1) + " 추가됨 (" + weights[i] + "kg)");
                    }
                }
            }
            setPstmt.executeBatch();
            System.out.println("모든 세트 저장 완료");
        }

        conn.commit(); 
        System.out.println("======= 커밋 완료 =======");
        out.println("<script>alert('오늘의 운동 기록이 성공적으로 저장되었습니다!'); location.href='../main.jsp';</script>");

    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch(SQLException ex) {}
        e.printStackTrace();
        System.out.println("에러 발생: " + e.getMessage());
        out.println("<script>alert('저장 중 오류가 발생했습니다: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>