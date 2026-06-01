<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, common.DBConnection" %>
<%
    request.setCharacterEncoding("UTF-8");

    String newPassword = request.getParameter("new_password");
    String confirmPassword = request.getParameter("confirm_password");
    String userId = (String) session.getAttribute("resetUserId");

    if (userId == null) {
%>
        <script>
            alert('유효하지 않은 접근입니다. 계정 찾기를 다시 진행해주세요.');
            location.href='../user/findAccount.jsp';
        </script>
<%
    } 
    else if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
%>
        <script>
            alert('입력하신 두 비밀번호가 서로 일치하지 않거나 비어있습니다.');
            history.back();
        </script>
<%
    } 
    else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        boolean isSamePassword = false;
        boolean isSuccess = false;

        try {
            conn = DBConnection.getConnection();
            
            String checkSql = "SELECT password FROM Users WHERE user_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                if (rs.getString("password").equals(newPassword)) {
                    isSamePassword = true;
                }
            }
            
            rs.close();
            pstmt.close();

            if (!isSamePassword) {
                String updateSql = "UPDATE Users SET password = ? WHERE user_id = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setString(1, newPassword);
                pstmt.setString(2, userId);
                
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    isSuccess = true;
                    session.removeAttribute("resetUserId");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if (conn != null) try { conn.close(); } catch(Exception e) {}
        }

        if (isSamePassword) {
%>
            <script>
                alert('기존 비밀번호와 동일합니다. 다른 비밀번호를 설정해주세요.');
                history.back();
            </script>
<%
        } else if (isSuccess) {
%>
            <script>
                alert('비밀번호가 성공적으로 변경되었습니다! 새 비밀번호로 로그인해주세요.');
                location.href='../user/login.jsp';
            </script>
<%
        } else {
%>
            <script>
                alert('비밀번호 변경 중 오류가 발생했습니다. 다시 시도해주세요.');
                history.back();
            </script>
<%
        }
    }
%>