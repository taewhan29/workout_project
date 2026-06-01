<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card-header-custom { background-color: #8bb8e8; color: white; font-weight: bold; }
        .btn-custom { background-color: #8bb8e8; color: white; font-weight: bold; border: none; }
        .btn-custom:hover { background-color: #75a2d1; color: white; }
        .form-control:focus { border-color: #8bb8e8; box-shadow: 0 0 0 0.25rem rgba(139, 184, 232, 0.25); }
        .join-link { text-decoration: none; color: #8bb8e8; font-size: 0.9rem; }
        .join-link:hover { color: #75a2d1; text-decoration: underline; }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header-custom text-center py-3 rounded-top">
                    <h5 class="mb-0">로그인</h5>
                </div>
                <div class="card-body p-4">
                    <form action="../actions/loginAction.jsp" method="post">
                        
                        <div class="mb-3">
                            <label for="user_id" class="form-label fw-bold">아이디</label>
                            <input type="text" class="form-control" id="user_id" name="user_id" required>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label fw-bold">비밀번호</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>

                        <div class="d-grid gap-2 mb-3">
                            <button type="submit" class="btn btn-custom btn-lg">로그인</button>
                        </div>

                        <div class="text-center">
                            <span class="text-muted small">계정이 없으신가요?</span> 
                            <a href="join.jsp" class="join-link ms-1 fw-bold">회원가입</a> 
                            <a href="findAccount.jsp" class="join-link ms-3 fw-bold">계정 찾기</a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>