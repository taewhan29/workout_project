<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 현재 브라우저와 연결된 모든 세션 정보를 무효화(삭제)합니다.
    session.invalidate(); 

    // 2. 세션이 삭제되었으므로 다시 로그인 페이지로 리다이렉트합니다.
    response.sendRedirect("../user/login.jsp"); 
%>