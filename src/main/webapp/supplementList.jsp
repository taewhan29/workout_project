<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Workout Tracker - 보충제 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Pretendard', sans-serif;
        }
        .navbar-custom {
            background-color: #8bb8e8;
        }
        .navbar-custom .navbar-brand, .navbar-custom .nav-link {
            color: white;
            font-weight: bold;
        }
        .navbar-custom .nav-link:hover {
            color: #f8f9fa;
        }
        .card-supp {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            background-color: white;
            transition: 0.3s;
        }
        .card-supp:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }
        .btn-custom {
            background-color: #8bb8e8;
            color: white;
            font-weight: bold;
            border: none;
            transition: 0.3s;
        }
        .btn-custom:hover {
            background-color: #75a2d1;
            color: white;
        }
        .icon-header {
            height: 1.2em;
            vertical-align: text-bottom;
            margin-right: 8px;
        }
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

    <nav class="navbar navbar-expand-lg navbar-custom shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/main.jsp">WORKOUT TRACKER</a>
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
                    <span class="text-white me-3 fw-bold">
                        <c:choose>
                            <c:when test="${not empty userName}">
                                ${userName}
                            </c:when>
                            <c:otherwise>
                                회원
                            </c:otherwise>
                        </c:choose> 님
                    </span> 
                    <a href="actions/logoutAction.jsp" class="btn btn-sm btn-light text-secondary fw-bold">로그아웃</a>
                </div>
                
            </div>
        </div>
    </nav>

    <div class="container" style="max-width: 900px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold text-secondary m-0">
                <img src="https://img.icons8.com/?size=100&id=MeZiNPN5N5O1&format=png&color=000000" class="icon-header" alt="보충제 아이콘"> 나의 보충제 재고 현황
            </h4>
            <button type="button" class="btn btn-custom btn-sm px-3 py-2 rounded-pill shadow-sm" data-bs-toggle="modal" data-bs-target="#addSupplementModal">
                + 보충제 등록
            </button>
        </div>
        
        <div class="row g-3">
            <c:choose>
                <c:when test="${not empty supplementsList}">
                    <c:forEach var="supp" items="${supplementsList}">
                        <div class="col-md-6">
                            <div class="card card-supp p-4">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h5 class="fw-bold text-dark mb-1">${supp.suppName}</h5>
                                        <span class="text-muted small">${supp.brand}</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${supp.currentServings <= supp.minThreshold}">
                                            <span class="badge bg-danger">재고부족</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success">안정</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <hr class="my-2 text-muted">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span class="text-secondary">남은 용량: <strong class="fs-5 text-primary"><fmt:formatNumber value="${supp.currentServings / 1000.0}" pattern="0.00"/></strong> kg</span>
                                    <span class="badge bg-light text-dark border">1회 섭취: ${supp.dosage} g</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/supplements?action=take&supp_id=${supp.suppId}&dosage=${supp.dosage}" class="btn btn-sm btn-custom py-2 fw-bold <c:if test='${supp.currentServings <= 0}'>disabled</c:if>">1회 섭취 완료 (-${supp.dosage}g)</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center var-5 text-muted py-5">
                        <p class="fs-5 m-0">등록된 보충제 정보가 없습니다.</p>
                        <p class="small text-secondary mt-1">우측 상단의 버튼을 눌러 첫 보충제를 등록해 주세요.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="modal fade" id="addSupplementModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px; border: none;">
                <div class="modal-header border-0 bg-light" style="border-top-left-radius: 15px; border-top-right-radius: 15px;">
                    <h5 class="modal-title fw-bold text-secondary">🆕 새 보충제 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/supplements" method="post">
                    <input type="hidden" name="action" value="insert">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">보충제 제품명</label>
                            <input type="text" name="supp_name" class="form-control" placeholder="예: 마이프로틴 스트로베리크림" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">제조사 / 브랜드</label>
                            <input type="text" name="brand" class="form-control" placeholder="예: 마이프로틴" required>
                        </div>
                        <div class="row g-2">
                            <div class="col-4">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">총 용량 (kg)</label>
                                    <input type="number" step="0.01" name="current_servings_kg" class="form-control no-spinners text-center" placeholder="예: 2.27" min="0.01" required>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">1회 섭취량 (g)</label>
                                    <input type="number" name="dosage_g" class="form-control no-spinners text-center" value="30" min="1" required>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">경고 기준 (kg)</label>
                                    <input type="number" step="0.01" name="min_threshold_kg" class="form-control no-spinners text-center" value="0.3" min="0" required>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-3 bg-light" style="border-bottom-left-radius: 15px; border-bottom-right-radius: 15px;">
                        <button type="submit" class="btn btn-custom px-4 rounded-pill">등록하기</button>
                        <button type="button" class="btn btn-secondary btn-sm px-3 rounded-pill" data-bs-dismiss="modal">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>