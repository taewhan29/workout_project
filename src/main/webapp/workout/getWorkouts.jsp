<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, common.DBConnection" %>
<%
    String partId = request.getParameter("part_id");
    if (partId == null || partId.trim().isEmpty()) {
        out.print("<option value=''>부위를 먼저 선택하세요</option>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT workout_id, workout_name FROM Standard_Workouts WHERE part_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(partId));
        rs = pstmt.executeQuery();

        boolean hasData = false;
        
        out.print("<option value='' selected disabled>운동을 선택하세요</option>");
        
        while (rs.next()) {
            hasData = true;
            int id = rs.getInt("workout_id");
            String name = rs.getString("workout_name");
            out.print("<option value='" + id + "'>" + name + "</option>");
        }

        if(!hasData){
            out.print("<option value=''>등록된 운동이 없습니다</option>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("<option value=''>DB 오류 발생</option>");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>