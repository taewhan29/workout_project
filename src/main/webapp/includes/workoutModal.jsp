<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="modal fade" id="workoutModal" tabindex="-1" aria-labelledby="workoutModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content" style="font-family: 'Pretendard', sans-serif; border-radius: 20px;">
            <div class="modal-header bg-dark text-white border-0">
                <h5 class="modal-title fw-bold" id="workoutModalLabel">💪 오늘의 루틴 기록</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 bg-light">
                <form action="actions/recordAction.jsp" method="post" id="workoutForm">
                    <div class="card shadow-sm border-0 mb-4 p-3">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">운동 날짜</label>
                                <input type="date" class="form-control border-0 bg-light" name="workout_date" id="todayDate" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">현재 체중 (kg)</label>
                                <input type="number" step="0.1" class="form-control border-0 bg-light" name="body_weight" placeholder="0.0">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">전체 컨디션 메모</label>
                                <textarea class="form-control border-0 bg-light" name="condition_note" rows="2" placeholder="오늘 몸 상태는 어땠나요?"></textarea>
                            </div>
                        </div>
                    </div>
                    <hr class="my-4">
                    <h6 class="fw-bold mb-3 text-secondary text-center">--- WORKOUT LIST ---</h6>
                    <div id="workoutContainer"></div>
                    <div class="text-center mt-3">
                        <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-bold" onclick="addWorkoutBlock()">+ 다른 운동 추가하기</button>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0 bg-white shadow-lg">
                <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">취소</button>
                <button type="submit" form="workoutForm" class="btn btn-custom px-5 fw-bold" style="background-color: #8bb8e8; color: white;">전체 기록 저장</button>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('todayDate').value = new Date().toISOString().substring(0, 10);
let workoutIdx = 0; 

function addWorkoutBlock() {
    workoutIdx++;
    const container = document.getElementById('workoutContainer');
    const block = document.createElement('div');
    block.className = 'card shadow-sm border-1 mb-4 workout-block border-primary'; 
    
    // JSP EL 충돌을 피하기 위해 문자열 결합 방식으로 작성
    var html = '';
    html += '<div class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center pt-3 pb-0">';
    html += '  <span class="badge rounded-pill bg-primary px-3 fs-6">운동 종목</span>';
    html += '  <button type="button" class="btn-close small" onclick="this.closest(\'.workout-block\').remove()"></button>';
    html += '  <input type="hidden" name="block_index" value="' + workoutIdx + '">';
    html += '</div>';
    html += '<div class="card-body">';
    html += '  <div class="row g-2 mb-3">';
    html += '    <div class="col-md-6">';
    html += '      <select class="form-select bg-light part-select" onchange="fetchWorkoutsForBlock(this)" required>';
    html += '        <option value="" selected disabled>부위 선택</option><option value="1">가슴</option><option value="2">등</option><option value="3">하체</option><option value="4">어깨</option>';
    html += '      </select>';
    html += '    </div>';
    html += '    <div class="col-md-6">';
    html += '      <select class="form-select bg-light workout-select" name="workout_id_' + workoutIdx + '" required>';
    html += '        <option value="">부위를 선택하세요</option>';
    html += '      </select>';
    html += '    </div>';
    html += '  </div>';
    html += '  <table class="table table-sm text-center align-middle mb-0">';
    html += '    <thead class="table-light"><tr style="font-size: 13px; color: #666;"><th style="width: 15%">세트</th><th style="width: 35%">무게(kg)</th><th style="width: 35%">횟수</th><th style="width: 15%">삭제</th></tr></thead>';
    html += '    <tbody class="set-tbody" data-idx="' + workoutIdx + '"></tbody>';
    html += '  </table>';
    html += '  <button type="button" class="btn btn-link btn-sm text-decoration-none mt-2 p-0 fw-bold" onclick="addSetToBlock(this)">+ 세트 추가</button>';
    html += '</div>';
    
    block.innerHTML = html;
    container.appendChild(block);
    addSetToBlock(block.querySelector('button[onclick="addSetToBlock(this)"]'));
}

function fetchWorkoutsForBlock(selectElement) {
    const partId = selectElement.value;
    const workoutSelect = selectElement.closest('.row').querySelector('.workout-select');
    workoutSelect.innerHTML = '<option value="">로딩 중...</option>';
    fetch('workout/getWorkouts.jsp?part_id=' + partId)
        .then(res => res.text())
        .then(html => { workoutSelect.innerHTML = html; });
}

function addSetToBlock(btnElement) {
    const tbody = btnElement.closest('.card-body').querySelector('.set-tbody');
    const bIdx = tbody.getAttribute('data-idx');
    const row = document.createElement('tr');
    
    var rowHtml = '';
    rowHtml += '<td><span class="fw-bold text-secondary set-number-text"></span></td>';
    rowHtml += '<td><input type="number" class="form-control form-control-sm text-center bg-light border-0" name="weight_' + bIdx + '" required></td>';
    rowHtml += '<td><input type="number" class="form-control form-control-sm text-center bg-light border-0" name="reps_' + bIdx + '" required></td>';
    rowHtml += '<td><button type="button" class="btn btn-sm text-danger border-0 fw-bold fs-5 p-0" onclick="removeSet(this)">×</button></td>';
    rowHtml += '<input type="hidden" name="rest_time_' + bIdx + '" value="60">';
    
    row.innerHTML = rowHtml;
    tbody.appendChild(row);
    reorderSets(tbody);
}

function removeSet(btnElement) {
    const tbody = btnElement.closest('tbody');
    btnElement.closest('tr').remove();
    reorderSets(tbody);
}

function reorderSets(tbody) {
    const spans = tbody.querySelectorAll('.set-number-text');
    spans.forEach((span, i) => { span.textContent = (i + 1) + "세트"; });
}

window.onload = function() { addWorkoutBlock(); }
</script>