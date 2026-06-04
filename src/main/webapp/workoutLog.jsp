<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.* , common.DBConnection, java.util.* "%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='user/login.jsp';</script>");
        return;
    }

    String userName = "";
    Connection conn = null;
    PreparedStatement pstmtName = null;
    ResultSet rsName = null;

    try {
        conn = DBConnection.getConnection();
        String nameSql = "SELECT name FROM Users WHERE user_id = ?";
        pstmtName = conn.prepareStatement(nameSql);
        pstmtName.setString(1, userId);
        rsName = pstmtName.executeQuery();
        if (rsName.next()) {
            userName = rsName.getString("name");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsName != null) try { rsName.close(); } catch (Exception e) { }
        if (pstmtName != null) try { pstmtName.close(); } catch (Exception e) { }
        if (conn != null) try { conn.close(); } catch (Exception e) { }
    }
%>
<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String logSql = "SELECT L.log_id, L.workout_date, L.body_weight, L.condition_note, " +
                       "S.set_order, S.weight, S.reps, S.workout_id, W.workout_name, B.part_name " +
                       "FROM Workout_Logs L " +
                       "LEFT JOIN Set_Records S ON L.log_id = S.log_id " +
                       "LEFT JOIN Standard_Workouts W ON S.workout_id = W.workout_id " +
                       "LEFT JOIN Body_Parts B ON W.part_id = B.part_id " +
                       "WHERE L.user_id = ? " +
                       "ORDER BY L.workout_date DESC, L.log_id DESC, W.workout_id ASC, S.set_order ASC";
        
        pstmt = conn.prepareStatement(logSql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>운동 일지 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; font-family: 'Pretendard', sans-serif; }
        .navbar-custom { background-color: #8bb8e8; }
        .navbar-custom .navbar-brand, .navbar-custom .nav-link { color: white; font-weight: bold; }
        .navbar-custom .nav-link:hover { color: #f8f9fa; }
        .card-log { border: none; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 25px; background-color: white; }
        .card-log-header { background-color: #f8f9fa; border-top-left-radius: 15px; border-top-right-radius: 15px; padding: 15px 20px; border-bottom: 1px solid #edf2f7; }
        .card-log-body { padding: 20px; }
        .badge-part { background-color: #e2e8f0; color: #4a5568; font-weight: bold; padding: 5px 10px; border-radius: 20px; font-size: 0.85rem; }
        .table-workout th { background-color: #f7fafc; color: #718096; font-size: 0.9rem; text-transform: uppercase; }
        .table-workout td { vertical-align: middle; }
        .no-spinners::-webkit-outer-spin-button,
        .no-spinners::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        .no-spinners {
            -moz-appearance: textfield;
        }
    </style>
    <script>
        function toggleLogEdit(logId, showEdit) {
            if (showEdit) {
                document.getElementById("view-area-" + logId).style.display = "none";
                document.getElementById("edit-form-" + logId).style.display = "block";
            } else {
                document.getElementById("view-area-" + logId).style.display = "block";
                document.getElementById("edit-form-" + logId).style.display = "none";
            }
        }
        function confirmDelete(logId) {
            if(confirm("해당 날짜의 모든 세트 데이터와 메인 일지가 영구 삭제됩니다.\n정말 삭제하시겠습니까?")) {
                location.href = "<%= request.getContextPath() %>/actions/deleteLogAction.jsp?log_id=" + logId;
            }
        }
    </script>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand" href="main.jsp">WORKOUT TRACKER</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto">
                 <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/workoutLog.jsp">운동 일지</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/supplements">보충제 관리</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/physicalInfo">신체 변화</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/myPage.jsp">마이페이지</a></li>
            </ul>
            <div class="d-flex align-items-center">
                <span class="text-white me-3 fw-bold"><%= userName %> 님</span> 
                <a href="<%= request.getContextPath() %>/actions/logoutAction.jsp" class="btn btn-sm btn-light text-secondary fw-bold">로그아웃</a>
            </div>
        </div>
    </div>
</nav>

<div class="container" style="max-width: 800px;">
    <h4 class="mb-4 fw-bold text-secondary">🏋️‍♂️ 나의 운동 기록 내역</h4>
<%
        int currentLogId = -1;
        boolean isFirstLog = true;
        boolean hasData = false;
        String currentWorkoutKey = "";
        boolean isFirstWorkoutInLog = true;

        List<String[]> currentLogSets = new ArrayList<String[]>();
        String logDate = "";
        double logWeight = 0.0;
        String logNote = "";

        StringBuilder viewHtml = new StringBuilder();
        StringBuilder editHtml = new StringBuilder();

        while (rs.next()) {
            hasData = true;
            int logId = rs.getInt("log_id");
            String date = rs.getString("workout_date");
            double weight = rs.getDouble("body_weight");
            String note = rs.getString("condition_note");
            if(note == null) note = "";
            
            int workoutId = rs.getInt("workout_id");
            String workoutName = rs.getString("workout_name");
            String partName = rs.getString("part_name");
            
            int setOrder = rs.getInt("set_order");
            double setWeight = rs.getDouble("weight");
            int reps = rs.getInt("reps");

            if (logId != currentLogId) {
                if (!isFirstLog) {
                    viewHtml.append("</tbody></table></div>");
                    
                    editHtml.append("</tbody></table></div>");
                    editHtml.append("<div class='mt-3 d-flex justify-content-end'>");
                    editHtml.append("<button type='submit' class='btn btn-sm btn-success me-2'>변경사항 저장</button>");
                    editHtml.append("<button type='button' class='btn btn-sm btn-secondary' onclick='toggleLogEdit(\"").append(currentLogId).append("\", false)'>취소</button>");
                    editHtml.append("</div></form></div>");

                    out.println("<div class='card card-log'>");
                    out.println("<div class='card-log-header d-flex justify-content-between align-items-center'>");
                    out.println("<div><span class='fs-5 fw-bold text-primary'>📅 " + logDate + "</span><span class='ms-3 text-muted fw-semibold'>⚖️ " + logWeight + "kg</span></div>");
                    out.println("<div><button type='button' class='btn btn-sm btn-outline-primary me-1' onclick='toggleLogEdit(\""+currentLogId+"\", true)'>일지 수정</button>");
                    out.println("<button type='button' class='btn btn-sm btn-outline-danger' onclick='confirmDelete(\""+currentLogId+"\")'>일지 삭제</button></div></div>");
                    out.println("<div class='card-log-body'>");
                    if(!logNote.trim().isEmpty()) {
                        out.println("<div class='p-3 bg-light rounded mb-3 text-secondary' style='font-size: 0.95rem;'>📝 " + logNote + "</div>");
                    }
                    out.println("<div id='view-area-" + currentLogId + "'>" + viewHtml.toString() + "</div>");
                    out.println("<div id='edit-form-" + currentLogId + "' style='display:none;'>" + editHtml.toString() + "</div>");
                    out.println("</div></div>");

                    viewHtml.setLength(0);
                    editHtml.setLength(0);
                }
                currentLogId = logId;
                isFirstLog = false;
                currentWorkoutKey = "";
                isFirstWorkoutInLog = true;
                
                logDate = date;
                logWeight = weight;
                logNote = note;

                editHtml.append("<div id='edit-area-").append(logId).append("'>");
                editHtml.append("<form action='").append(request.getContextPath()).append("/actions/updateSetAction.jsp' method='post'>");
                editHtml.append("<input type='hidden' name='log_id' value='").append(logId).append("'>");
                editHtml.append("<div class='row g-2 mb-3'>");
                editHtml.append("<div class='col-6'><label class='form-label small fw-bold'>운동 날짜</label><input type='date' name='workout_date' class='form-control form-control-sm' value='").append(date).append("' required></div>");
                editHtml.append("<div class='col-6'><label class='form-label small fw-bold'>당일 체중 (kg)</label><input type='number' step='0.1' name='body_weight' class='form-control form-control-sm no-spinners' value='").append(weight).append("'></div>");
                editHtml.append("<div class='col-12'><label class='form-label small fw-bold'>컨디션 메모</label><input type='text' name='condition_note' class='form-control form-control-sm' value='").append(note).append("'></div>");
                editHtml.append("</div>");
            }

            String workoutKey = logId + "_" + workoutId;
            if (!workoutKey.equals(currentWorkoutKey)) {
                if (!isFirstWorkoutInLog) {
                    viewHtml.append("</tbody></table>");
                    editHtml.append("</tbody></table>");
                }
                currentWorkoutKey = workoutKey;
                isFirstWorkoutInLog = false;

                viewHtml.append("<div class='d-flex align-items-center mb-2 mt-3'>");
                viewHtml.append("<span class='badge badge-part me-2'>").append(partName).append("</span>");
                viewHtml.append("<span class='fw-bold fs-6 text-dark'>").append(workoutName).append("</span></div>");
                viewHtml.append("<table class='table table-sm table-bordered table-workout text-center mb-3'><thead><tr><th style='width: 20%;'>세트</th><th style='width: 40%;'>무게</th><th style='width: 40%;'>횟수</th></tr></thead><tbody>");

                editHtml.append("<div class='d-flex align-items-center mb-2 mt-3'>");
                editHtml.append("<span class='badge badge-part me-2'>").append(partName).append("</span>");
                editHtml.append("<span class='fw-bold fs-6 text-dark'>").append(workoutName).append("</span></div>");
                editHtml.append("<table class='table table-sm table-bordered table-workout text-center mb-3'><thead><tr><th style='width: 20%;'>세트</th><th style='width: 40%;'>무게</th><th style='width: 40%;'>횟수</th></tr></thead><tbody>");
            }

            viewHtml.append("<tr><td>").append(setOrder).append("세트</td><td>").append(setWeight).append(" kg</td><td>").append(reps).append(" 회</td></tr>");

            editHtml.append("<tr><td>").append(setOrder).append("세트</td>");
            editHtml.append("<td><input type='hidden' name='set_order[]' value='").append(setOrder).append("'>");
            editHtml.append("<input type='hidden' name='workout_id[]' value='").append(workoutId).append("'>");
            editHtml.append("<input type='number' step='0.1' name='weight[]' class='form-control form-control-sm text-center d-inline-block no-spinners' style='width: 100px;' value='").append(setWeight).append("' required> kg</td>");
            editHtml.append("<td><input type='number' name='reps[]' class='form-control form-control-sm text-center d-inline-block' style='width: 100px;' value='").append(reps).append("' required> 회</td></tr>");
        }

        if (hasData) {
            viewHtml.append("</tbody></table></div>");
            
            editHtml.append("</tbody></table></div>");
            editHtml.append("<div class='mt-3 d-flex justify-content-end'>");
            editHtml.append("<button type='submit' class='btn btn-sm btn-success me-2'>변경사항 저장</button>");
            editHtml.append("<button type='button' class='btn btn-sm btn-secondary' onclick='toggleLogEdit(\"").append(currentLogId).append("\", false)'>취소</button>");
            editHtml.append("</div></form></div>");

            out.println("<div class='card card-log'>");
            out.println("<div class='card-log-header d-flex justify-content-between align-items-center'>");
            out.println("<div><span class='fs-5 fw-bold text-primary'>📅 " + logDate + "</span><span class='ms-3 text-muted fw-semibold'>⚖️ " + logWeight + "kg</span></div>");
            out.println("<div><button type='button' class='btn btn-sm btn-outline-primary me-1' onclick='toggleLogEdit(\""+currentLogId+"\", true)'>일지 수정</button>");
            out.println("<button type='button' class='btn btn-sm btn-outline-danger' onclick='confirmDelete(\""+currentLogId+"\")'>일지 삭제</button></div></div>");
            out.println("<div class='card-log-body'>");
            if(!logNote.trim().isEmpty()) {
                out.println("<div class='p-3 bg-light rounded mb-3 text-secondary' style='font-size: 0.95rem;'>📝 " + logNote + "</div>");
            }
            out.println("<div id='view-area-" + currentLogId + "'>" + viewHtml.toString() + "</div>");
            out.println("<div id='edit-form-" + currentLogId + "' style='display:none;'>" + editHtml.toString() + "</div>");
            out.println("</div></div>");
        } else {
%>
    <div class="text-center py-5 text-muted">
        <p class="fs-5">아직 기록된 운동 일지가 없습니다.</p>
        <a href="main.jsp" class="btn btn-primary btn-sm mt-2">첫 운동 기록하러 가기</a>
    </div>
<%
        }
%>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>