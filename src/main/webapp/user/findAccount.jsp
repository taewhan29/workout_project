<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>계정 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card-header-custom { background-color: #8bb8e8; color: white; font-weight: bold; }
        .btn-custom { background-color: #8bb8e8; color: white; font-weight: bold; border: none; }
        .btn-custom:hover { background-color: #75a2d1; color: white; }
        .form-control:focus { border-color: #8bb8e8; box-shadow: 0 0 0 0.25rem rgba(139, 184, 232, 0.25); }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header-custom text-center py-3 rounded-top">
                    <h5 class="mb-0">계정 찾기 및 비밀번호 재설정</h5>
                </div>
                <div class="card-body p-4">
                    <p class="text-muted small text-center mb-4">가입 시 등록한 이름과 이메일을 입력해주세요.</p>
                    
                    <form action="../actions/findAccountAction.jsp" method="post">
                        
                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">이름</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>

                        <div class="mb-4">
                            <label for="email" class="form-label fw-bold">이메일</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>

                        <div class="d-grid gap-2 mb-3">
                            <button type="submit" class="btn btn-custom btn-lg">본인 확인</button>
                        </div>
                        
                        <div class="text-center mt-3">
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="location.href='login.jsp'">로그인으로 돌아가기</button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>