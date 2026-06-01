<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.* , common.DBConnection, java.util.* "%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='user/login.jsp';</script>");
        return;
    }

    String mode = request.getParameter("mode");
    if (mode != null) {
        Connection connUpdate = null;
        PreparedStatement pstmtUpdate = null;
        try {
            connUpdate = DBConnection.getConnection();
            if (mode.equals("updateMaster")) {
                String logIdStr = request.getParameter("log_id");
                String wDate = request.getParameter("workout_date");
                String bWeight = request.getParameter("body_weight");
                String cNote = request.getParameter("condition_note");
                
                String sql = "UPDATE Workout_Logs SET workout_date = ?, body_weight = ?, condition_note = ? WHERE log_id = ? AND user_id = ?";
                pstmtUpdate = connUpdate.prepareStatement(sql);
                pstmtUpdate.setString(1, wDate);
                pstmtUpdate.setDouble(2, Double.parseDouble(bWeight));
                pstmtUpdate.setString(3, cNote);
                pstmtUpdate.setInt(4, Integer.parseInt(logIdStr));
                pstmtUpdate.setString(5, userId);
                pstmtUpdate.executeUpdate();
                out.println("<script>alert('운동 일지 정보가 수정되었습니다.'); location.href='workoutLog.jsp';</script>");
                return;
            } else if (mode.equals("updateSet")) {
                String logIdStr = request.getParameter("log_id");
                String sOrderStr = request.getParameter("set_order");
                String weightStr = request.getParameter("weight");
                String repsStr = request.getParameter("reps");
                
                String sql = "UPDATE Set_Records SET weight = ?, reps = ? WHERE log_id = ? AND set_order = ?";
                pstmtUpdate = connUpdate.prepareStatement(sql);
                pstmtUpdate.setDouble(1, Double.parseDouble(weightStr));
                pstmtUpdate.setInt(2, Integer.parseInt(repsStr));
                pstmtUpdate.setInt(3, Integer.parseInt(logIdStr));
                pstmtUpdate.setInt(4, Integer.parseInt(sOrderStr));
                pstmtUpdate.executeUpdate();
                out.println("<script>alert('세트 정보가 수정되었습니다.'); location.href='workoutLog.jsp';</script>");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('처리 중 에러가 발생했습니다.'); history.back();</script>");
            return;
        } finally {
            if (pstmtUpdate != null) try { pstmtUpdate.close(); } catch (Exception e) {}
            if (connUpdate != null) try { connUpdate.close(); } catch (Exception e) {}
        }
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
        body { background-color: #f4f7f6; }
        .navbar-custom { background-color: #8bb8e8; }
        .navbar-custom .navbar-brand, .navbar-custom .nav-link { color: white; font-weight: bold; }
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
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom mb-4">
    <div class="container">
        <a class="navbar-brand" href="main.jsp">WORKOUT TRACKER</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-link" style="color: white; margin-right: 15px;"><%= userName %> 님</li>
                <li class="nav-item"><a class="nav-link" href="myPage.jsp">마이페이지</a></li>
                <li class="nav-item"><a class="nav-link" href="user/logoutAction.jsp">로그아웃</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container" style="max-width: 800px;">
    <h3 class="mb-4 text-dark font-weight-bold">나의 운동 기록 내역</h3>
<%
        int currentLogId = -1;
        boolean isFirstLog = true;
        boolean hasData = false;
        String currentWorkoutKey = "";
        boolean isFirstWorkoutInLog = true;

        while (rs.next()) {
            hasData = true;
            int logId = rs.getInt("log_id");
            String date = rs.getString("workout_date");
            double weight = rs.getDouble("body_weight");
            String note = rs.getString("condition_note");
            
            int workoutId = rs.getInt("workout_id");
            String workoutName = rs.getString("workout_name");
            String partName = rs.getString("part_name");
            
            int setOrder = rs.getInt("set_order");
            double setWeight = rs.getDouble("weight");
            int reps = rs.getInt("reps");

            if (logId != currentLogId) {
                if (!isFirstLog) {
%>
                            </tbody>
                        </table>
                    </div>
                </div>
<%
                }
                currentLogId = logId;
                isFirstLog = false;
                currentWorkoutKey = "";
                isFirstWorkoutInLog = true;
%>
    <div class="card card-log" id="log_card_<%= logId %>">
        <div class="card-log-header d-flex justify-content-between align-items-center">
            <div class="master-info-area d-flex align-items-center">
                <span class="fs-5 fw-bold text-primary date-text">📅 <%= date %></span>
                <span class="ms-3 text-muted fw-semibold weight-text"> <%= weight %>kg</span>
            </div>
            <div class="master-btn-area">
                <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="enableMasterEdit('<%= logId %>', '<%= date %>', '<%= weight %>')">일지 수정</button>
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="confirmDelete('<%= logId %>')">일지 삭제</button>
            </div>
        </div>
        <div class="card-log-body">
            <div class="note-area p-3 bg-light rounded mb-3 text-secondary" style="font-size: 0.95rem;">
                📝 <span class="note-text"><%= (note != null && !note.trim().isEmpty()) ? note : "등록된 컨디션 메모가 없습니다." %></span>
            </div>
<%
        }

        String workoutKey = logId + "_" + workoutId;
        if (!workoutKey.equals(currentWorkoutKey)) {
            if (!isFirstWorkoutInLog) {
%>
                    </tbody>
                </table>
<%
            }
            currentWorkoutKey = workoutKey;
            isFirstWorkoutInLog = false;
%>
            <div class="d-flex align-items-center mb-2 mt-3">
                <span class="badge badge-part me-2"><%= partName %></span>
                <span class="fw-bold fs-6 text-dark"><%= workoutName %></span>
            </div>
            <table class="table table-sm table-bordered table-workout text-center mb-3">
                <thead>
                    <tr>
                        <th style="width: 15%;">세트</th>
                        <th style="width: 30%;">무게</th>
                        <th style="width: 30%;">횟수</th>
                        <th style="width: 25%;">관리</th>
                    </tr>
                </thead>
                <tbody>
<%
        }
%>
                    <tr id="row_<%= logId %>_<%= setOrder %>">
                        <td><%= setOrder %>세트</td>
                        <td class="weight-val"><%= setWeight %> kg</td>
                        <td class="reps-val"><%= reps %> 회</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="enableEdit('<%= logId %>', '<%= setOrder %>', '<%= setWeight %>', '<%= reps %>')">수정</button>
                        </td>
                    </tr>
<%
        }
        if (hasData) {
%>
                            </tbody>
                        </table>
                    </div>
                </div>
<%
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

<script>
function confirmDelete(logId) {
    if(confirm("해당 날짜의 모든 세트 데이터와 메인 일지가 영구 삭제됩니다.\n정말 삭제하시겠습니까?")) {
        location.href = "actions/deleteLogAction.jsp?log_id=" + logId;
    }
}

function enableEdit(logId, setOrder, currentWeight, currentReps) {
    const row = document.getElementById("row_" + logId + "_" + setOrder);
    const weightTd = row.querySelector(".weight-val");
    const repsTd = row.querySelector(".reps-val");
    const btnTd = row.cells[3];

    weightTd.innerHTML = '<input type="number" step="0.1" class="form-control form-control-sm text-center d-inline-block no-spinners" style="width: 80px;" value="' + currentWeight + '"> kg';
    repsTd.innerHTML = '<input type="number" class="form-control form-control-sm text-center d-inline-block" style="width: 80px;" value="' + currentReps + '"> 회';
    
    btnTd.innerHTML = '<button type="button" class="btn btn-sm btn-success me-1" onclick="saveEdit(\'' + logId + '\', \'' + setOrder + '\')">저장</button>' +
                       '<button type="button" class="btn btn-sm btn-secondary" onclick="location.reload()">취소</button>';
}

function saveEdit(logId, setOrder) {
    const row = document.getElementById("row_" + logId + "_" + setOrder);
    const weightInput = row.querySelector(".weight-val input").value;
    const repsInput = row.querySelector(".reps-val input").value;

    if(!weightInput || !repsInput) {
        alert("무게와 횟수를 올바르게 입력하세요.");
        return;
    }

    location.href = "workoutLog.jsp?mode=updateSet&log_id=" + logId + "&set_order=" + setOrder + "&weight=" + weightInput + "&reps=" + repsInput;
}

function enableMasterEdit(logId, currentDate, currentWeight) {
    const card = document.getElementById("log_card_" + logId);
    const infoArea = card.querySelector(".master-info-area");
    const btnArea = card.querySelector(".master-btn-area");
    const noteArea = card.querySelector(".note-area");
    
    let rawNote = card.querySelector(".note-text").innerText;
    if(rawNote === "등록된 컨디션 메모가 없습니다.") {
        rawNote = "";
    }

    infoArea.innerHTML = '<input type="date" class="form-control form-control-sm d-inline-block me-2" style="width: 140px;" value="' + currentDate + '">' +
                         '<input type="number" step="0.1" class="form-control form-control-sm d-inline-block no-spinners" style="width: 80px;" value="' + currentWeight + '"> kg';
    
    noteArea.innerHTML = '📝 <textarea class="form-control form-control-sm mt-1" rows="2">' + rawNote + '</textarea>';

    btnArea.innerHTML = '<button type="button" class="btn btn-sm btn-success me-1" onclick="saveMasterEdit(\'' + logId + '\')">저장</button>' +
                        '<button type="button" class="btn btn-sm btn-secondary" onclick="location.reload()">취소</button>';
}

function saveMasterEdit(logId) {
    const card = document.getElementById("log_card_" + logId);
    const inputs = card.querySelectorAll(".master-info-area input");
    const dateInput = inputs[0].value;
    const weightInput = inputs[1].value;
    const noteInput = card.querySelector(".note-area textarea").value;

    if(!dateInput || !weightInput) {
        alert("날짜와 체중을 올바르게 입력하세요.");
        return;
    }

    const form = document.createElement("form");
    form.method = "POST";
    form.action = "workoutLog.jsp";

    const params = { mode: "updateMaster", log_id: logId, workout_date: dateInput, body_weight: weightInput, condition_note: noteInput };
    for(let key in params) {
        let hiddenField = document.createElement("input");
        hiddenField.type = "hidden";
        hiddenField.name = key;
        hiddenField.value = params[key];
        form.appendChild(hiddenField);
    }

    document.body.appendChild(form);
    form.submit();
}
</script>

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