<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card-header-custom { background-color: #8bb8e8; color: white; font-weight: bold; }
        .btn-custom { background-color: #8bb8e8; color: white; font-weight: bold; border: none; }
        .btn-custom:hover { background-color: #75a2d1; color: white; }
        .form-control:focus, .form-select:focus {
            border-color: #8bb8e8;
            box-shadow: 0 0 0 0.25rem rgba(139, 184, 232, 0.25);
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header-custom text-center py-3 rounded-top">
                    <h5 class="mb-0">회원가입</h5>
                </div>
                <div class="card-body p-4">
                    <form action="../actions/joinAction.jsp" method="post">
                        
                        <div class="mb-3">
                            <label for="user_id" class="form-label fw-bold">아이디</label>
                            <input type="text" class="form-control" id="user_id" name="user_id" required maxlength="20">
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label fw-bold">비밀번호</label>
                            <input type="password" class="form-control" id="password" name="password" required maxlength="100">
                        </div>

                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">이름</label>
                            <input type="text" class="form-control" id="name" name="name" required maxlength="20">
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label fw-bold">이메일</label>
                            <input type="email" class="form-control" id="email" name="email" maxlength="50">
                        </div>

                        <div class="mb-4">
                            <label for="gender" class="form-label fw-bold">성별</label>
                            <select class="form-select" id="gender" name="gender">
                                <option value="">선택안함</option>
                                <option value="M">남성</option>
                                <option value="F">여성</option>
                                <option value="None">답변하지않음</option>
                            </select>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-custom btn-lg">가입하기</button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>