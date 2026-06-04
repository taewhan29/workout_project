<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Workout Tracker - 신체 정보 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Pretendard', sans-serif; }
        .navbar-custom { background-color: #8bb8e8; }
        .navbar-custom .navbar-brand, .navbar-custom .nav-link { color: white; font-weight: bold; }
        .navbar-custom .nav-link:hover { color: #f8f9fa; }
        .card-custom { border: none; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); background-color: white; padding: 25px; }
        .btn-custom { background-color: #8bb8e8; color: white; font-weight: bold; border: none; transition: 0.3s; }
        .btn-custom:hover { background-color: #75a2d1; color: white; }
        .icon-header { height: 1.2em; vertical-align: text-bottom; margin-right: 8px; }
        .table-custom th { background-color: #f8f9fa; color: #6c757d; font-weight: bold; text-align: center; }
        .table-custom td { text-align: center; vertical-align: middle; }
        .no-spinners::-webkit-outer-spin-button, .no-spinners::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        .no-spinners { -moz-appearance: textfield; }
    </style>
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
                    <li class="nav-item"><a class="nav-link" href="workoutLog.jsp">운동 일지</a></li>
                    <li class="nav-item"><a class="nav-link" href="supplements">보충제 관리</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/physicalInfo">신체 변화</a></li>
                    <li class="nav-item"><a class="nav-link" href="myPage.jsp">마이페이지</a></li>
                </ul>
                <div class="d-flex align-items-center">
                    <span class="text-white me-3 fw-bold">${userName} 님</span> 
                    <a href="${pageContext.request.contextPath}/actions/logoutAction.jsp" class="btn btn-sm btn-light text-secondary fw-bold">로그아웃</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container" style="max-width: 850px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold text-secondary m-0">
                <img src="https://img.icons8.com/?size=100&id=114322&format=png&color=000000" class="icon-header" alt="체중계"> 나의 신체 변화 내역
            </h4>
            <button type="button" class="btn btn-custom btn-sm px-3 py-2 rounded-pill shadow-sm" data-bs-toggle="modal" data-bs-target="#addPhysicalModal">
                + 신체 정보 기록
            </button>
        </div>

        <div class="card card-custom">
            <div class="table-responsive">
                <table class="table table-hover table-custom m-0">
                    <thead>
                        <tr>
                            <th>측정 날짜</th>
                            <th>체중 (kg)</th>
                            <th>골격근량 (kg)</th>
                            <th>체지방률 (%)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty physicalHistoryList}">
                                <c:forEach var="row" items="${physicalHistoryList}">
                                    <tr>
                                        <td class="fw-bold text-secondary">${row.measuerDate}</td>
                                        <td class="text-dark fw-semibold">${row.weight} kg</td>
                                        <td class="text-primary fw-bold">${row.musdeMass} kg</td>
                                        <td class="text-danger fw-semibold">${row.bodyFatPct} %</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-5">
                                        기록된 신체 변화 데이터가 없습니다.<br>
                                        우측 상단 버튼을 눌러 인바디 기록을 추가해 보세요!
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addPhysicalModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px; border: none;">
                <div class="modal-header border-0 bg-light" style="border-top-left-radius: 15px; border-top-right-radius: 15px;">
                    <h5 class="modal-title fw-bold text-secondary">📊 신체 계측 정보 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/physicalInfo" method="post">
                    <input type="hidden" name="action" value="insert">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">측정 날짜</label>
                            <input type="date" name="measuer_date" class="form-control" required id="currentDate">
                        </div>
                        <div class="row g-2">
                            <div class="col-4">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">체중 (kg)</label>
                                    <input type="number" step="0.1" name="weight" class="form-control no-spinners text-center" placeholder="0.0" min="1" required>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">골격근량 (kg)</label>
                                    <input type="number" step="0.1" name="musde_mass" class="form-control no-spinners text-center" placeholder="0.0" min="1" required>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">체지방률 (%)</label>
                                    <input type="number" step="0.1" name="body_fat_pct" class="form-control no-spinners text-center" placeholder="0.0" min="0.1" max="100" required>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-3 bg-light" style="border-bottom-left-radius: 15px; border-bottom-right-radius: 15px;">
                        <button type="submit" class="btn btn-custom px-4 rounded-pill">기록하기</button>
                        <button type="button" class="btn btn-secondary btn-sm px-3 rounded-pill" data-bs-dismiss="modal">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('currentDate').value = new Date().toISOString().substring(0, 10);
    </script>
</body>
</html>